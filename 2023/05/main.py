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

if __name__ == "__main__":
    main()

