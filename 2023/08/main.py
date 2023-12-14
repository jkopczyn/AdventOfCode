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
    location = "AAA"
    steps = 0
    while location != "ZZZ":
        step = moves[(steps % len(moves))]
        steps += 1
        if step == "L":
            location = lefts[location]
        elif step == "R":
            location = rights[location]
        else:
            raise Exception(step, "is an invalid step")
    print(steps)
 

if __name__ == "__main__":
    main()

