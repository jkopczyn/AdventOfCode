#! /usr/bin/env python3
import sys
import argparse

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
            "input", nargs="?", default="-",
            metavar="INPUT_FILE", type=argparse.FileType("r"),
            help="path to the input file (read from stdin if omitted)")
    parser.add_argument(
            "output", nargs="?", default="-",
            metavar="OUTPUT_FILE", type=argparse.FileType("w"),
            help="path to the output file (write to stdout if omitted)")
    args = parser.parse_args()
    seedslines = []
    soillines = []
    fertilizerlines = []
    waterlines = []
    lightlines = []
    templines = []
    humidlines = []
    loclines = []
    step = 0
    for line in args.input:
        if line.strip() == "":
            step += 1
            continue
        if step == 0:
            seedslines.append(line)
        elif step == 1:
            soillines.append(line)
        elif step == 2:
            fertilizerlines.append(line)
        elif step == 3:
            waterlines.append(line)
        elif step == 4:
            lightlines.append(line)
        elif step == 5:
            templines.append(line)
        elif step == 6:
            humidlines.append(line)
        elif step == 7:
            loclines.append(line)

    cleanseedsline = seedslines[0].split(":")[-1]
    print(cleanseedsline)
    # seeds = list(sorted(int(s) for s in cleanseedline.split(" ") if s.strip() != ""))
    seeds = seedranges(cleanseedsline)
    mutated = list(s for s in seeds)

    for transition in [soillines, fertilizerlines, waterlines, lightlines, templines, humidlines, loclines]:
        mutated = mutate(mutated, clean(transition))
    for idx in range(len(seeds)):
        print(seeds[idx], mutated[idx])
    print(min(mutated))

def seedranges(seedsline):
    seeds = []
    start = -1
    nums = list(int(s) for s in seedsline.split(" ") if s.strip() != "")
    for n in nums:
        if start == -1:
            start = n
        else:
            seeds.append((start, start+n-1))
            start = -1
    print(len(seeds))
    return seeds


def mutate(lst, inputs):
    oldlist = [x for x in lst]
    newlist = []
    for inp in inputs:
        oldlist, newlist = singlemutate(oldlist, newlist, inp)
    newlist = infill(lst, newlist)
    # print(newlist)
    return newlist

def singlemutate(srclist, destlist, triple):
    dest, src, length = triple
    targetrange = range(src, src+length)
    diff = dest - src
    for idx in range(len(srclist)):
        if srclist[idx] in targetrange:
            if destlist[idx] != -1:
                raise(Exception(idx))
            destlist[idx] = srclist[idx] + diff
    return destlist

def infill(srclist, destlist):
    for idx in range(len(srclist)):
        if destlist[idx] == -1:
            destlist[idx] = srclist[idx]
    return destlist

def clean(lines):
    triples = []
    for l in lines:
        if "map" in l:
            continue
        a, b, c = (int(x.strip()) for x in l.split(" "))
        triples.append((a,b,c))
    # print(triples)
    return triples

if __name__ == "__main__":
    main()

