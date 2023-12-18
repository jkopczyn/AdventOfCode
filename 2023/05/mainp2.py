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
        line = line.strip()
        if line == "":
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
    mutated = [s for s in seeds]

    for transition in [soillines, fertilizerlines, waterlines, lightlines, templines, humidlines, loclines]:
        # print(mutated, transition)
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
    # print(len(seeds))
    return seeds


def mutate(lst, inputs):
    oldlist = [x for x in lst]
    newlist = []
    for inp in inputs:
        oldlist, newlist = singlemutate(oldlist, newlist, inp)
    newlist = infill(oldlist, newlist)
    # print(newlist)
    return newlist

def singlemutate(srclist, destlist, triple):
    dest, src, length = triple
    targetrange = (src, src+length-1)
    diff = dest - src
    mutated_srclist = []
    for oldrange in srclist:
        olds, news = intersect(oldrange, targetrange, diff)
        mutated_srclist.extend(olds)
        destlist.extend(news)
    return mutated_srclist, destlist

def intersect(oldrange, targetrange, diff):
    a,b = oldrange
    c,d = targetrange
    if b < c or d < a:
        return [oldrange], []
    olds, news  = [], []
    if a < c:
        olds.append((a,c-1))
    if d < b:
        olds.append((d+1, b))
    if a <= c and c <= b:
        if d < b:
            news.append((c+diff, d+diff))
        else:
            news.append((c+diff, b+diff))
    if c <= a:
        if d < b:
            news.append((a+diff, d+diff))
        else:
            news.append((a+diff, b+diff))
    return olds, news

def infill(srclist, destlist):
    destlist.extend(srclist)
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

