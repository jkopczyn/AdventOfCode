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

    cleanseedline = seedslines[0].split(":")[-1]
    seeds = list(sorted(int(s) for s in cleanseedline.split(" ") if s.strip() != ""))

    initial = list(range(max(seeds)+1))
    mutated = list(range(max(seeds)+1))
    for transition in [soillines, fertilizerlines, waterlines, lightlines, templines, humidlines, loclines]:
        mutated = mutate(mutated, clean(transition))
    for seed in seeds:
        print(seed, mutated[seed])

def mutate(lst, inputs):
    for inp in inputs:
        lst = singlemutate(lst, inp)
    print(lst)
    return lst

def singlemutate(lst, triple):
    dest, src, length = triple
    targetrange = range(src, src+length)
    diff = dest - src
    for idx in range(len(lst)):
        if lst[idx] in targetrange:
            lst[idx] += diff
    return lst

def clean(lines):
    triples = []
    for l in lines:
        if "map" in l:
            continue
        a, b, c = (int(x.strip()) for x in l.split(" "))
        triples.append((a,b,c))
    print(triples)
    return triples

if __name__ == "__main__":
    main()

