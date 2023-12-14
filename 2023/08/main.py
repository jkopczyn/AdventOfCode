#! /usr/bin/env python3
import sys
import argparse
import math

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
    moves = args.input.readline().strip()
    _ = args.input.readline()
    print(moves, "moves")
    lefts = {}
    rights = {}
    for line in args.input:
        key, directions = (x.strip() for x in line.split("="))
        left, right = (x.strip() for x in directions.strip("() ").split(","))
        lefts[key] = left
        rights[key] = right
    locations = starts(lefts)
    distances = [0]*len(locations)
    steps = 0
    while True:
        step = moves[(steps % len(moves))]
        steps += 1
        newlocs = []
        for idx in range(len(locations)):
            location = locations[idx]
            if step == "L":
                newlocs.append(lefts[location])
            elif step == "R":
                newlocs.append(rights[location])
            else:
                raise Exception(step, "is an invalid step")
            newloc = newlocs[-1]
            if distances[idx] == 0 and newloc[-1] == "Z":
                distances[idx] = steps
        if len(list(x for x in distances if x == 0)) == 0:
            break
        locations = newlocs
    print(math.lcm(*distances))
    print(steps)

def starts(paths):
    s = []
    for k, _ in paths.items():
        if k[-1] == "A":
            s.append(k)
    return s

def done(locations):
    for loc in locations:
        if loc[-1] != "Z":
            return False
    return True

if __name__ == "__main__":
    main()

