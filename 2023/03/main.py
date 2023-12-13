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
    lines = []
    grid = []
    totalpart = 0
    for line in args.input:
        lines.append(line.strip())
        grid.append(list(line.strip()))
    for y in range(len(grid)):
        for x in range(len(grid[y])):
            if grid[y][x] not in "0123456789.":
                newgrid, parts = select(grid, x, y)
                print(parts, file=args.output)
                for part in parts:
                    totalpart += part
                grid = newgrid
    print("", file=args.output)

def select(grid, x, y):
    # look above
    # look left
    # look right
    # look below
    return grid, []
 

if __name__ == "__main__":
    main()

