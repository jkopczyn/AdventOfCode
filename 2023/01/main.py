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
    for idx in range(len(line)):
        d = digit(line, idx)
        if d >= 0:
            if first < 0:
                first = d
                last = first
            else:
                last = d
    return 10*first+last

def digit(line, idx):
    if line[idx] in "0123456789":
        return int(line[idx])
    mapper = {"one": 1, "two": 2, "three": 3, "four": 4, "five": 5, "six": 6, "seven": 7, "eight": 8, "nine": 9}
    if line[idx:idx+3] in ["six", "two", "one"]:
        return mapper[line[idx:idx+3]]
    if line[idx:idx+4] in ["four", "five", "nine"]:
        return mapper[line[idx:idx+4]]
    if line[idx:idx+5] in ["three", "seven", "eight"]:
        return mapper[line[idx:idx+5]]
    return -1

if __name__ == "__main__":
    main()

