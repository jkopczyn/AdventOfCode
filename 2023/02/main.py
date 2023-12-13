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
    for line in args.input:
        game, pulls = line.split(":")
        print(line.strip(), file=args.output)

def getgame(s):
    return s[-1]

def total(pulls):
    ts = {"r": 0, "g": 0, "b": 0}
    return ts

#  Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
if __name__ == "__main__":
    main()

