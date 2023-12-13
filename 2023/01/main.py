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
    total = 0
    for line in args.input:
        total += numerals(line)
    print(total, file=args.output)

def numerals(line):
    first = -1
    last = -1
    for c in line:
        if c in "0123456789":
            if first < 0:
                first = int(c)
                last = first
            else:
                last = int(c)
    return 10*first+last


if __name__ == "__main__":
    main()

