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
    patterns = []
    pattern = []
    for line in args.input:
        if line.strip() == "":
            patterns.append(pattern)
            pattern = []
            continue
        pattern.append(line.strip())
    patterns.append(pattern)

    for pattern in patterns:
        print("rows")
        for row in pattern:
            print(line_mirrored_splits(row))
        print("columns")
        for idx in range(len(row)):
            col = list(r[idx] for r in pattern)
            print(line_mirrored_splits(col))
    print("", file=args.output)

def line_mirrored_splits(line):
    splits = []
    for split in range(1,len(line)-1):
        step = 1
        mirrored = True
        while step <= split and split+step <= len(line):
            if line[split-step] != line[split+step-1]:
                mirrored = False
                break
            step += 1
        if mirrored:
            splits.append(split)
    return splits


if __name__ == "__main__":
    main()

