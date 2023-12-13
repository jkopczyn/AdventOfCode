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
    print(grid)
    print(totalpart, file=args.output)

def select(grid, x, y):
    parts = []
    # look above
    if y>0:
        pass
    # look left
    if x>0 and isnum(grid[y][x-1]):
        num, left, right = bounds(grid[y], x-1)
        clear(grid, y, left, right)
        parts.append(num)
    # look right
    if x<(len(grid[0])-1) and isnum(grid[y][x+1]):
        num, left, right = bounds(grid[y], x+1)
        clear(grid, y, left, right)
        parts.append(num)
    # look below
    if y<(len(grid)-1):
        pass
    return grid, parts

def isnum(c):
    return (c in "0123456789")

def clear(grid, row, left, right):
    for idx in range(left, right+1):
        grid[row][idx] = "."

def bounds(row, point):
    left = point
    right = point
    for idx in range(point, -1, -1):
        if isnum(row[idx]):
            left = idx
            continue
        break
    for idx in range(point, len(row)):
        if isnum(row[idx]):
            right = idx
            continue
        break
    num = int("".join(row[left:right+1]))
    return num, left, right

if __name__ == "__main__":
    main()

