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
    # allparts(args)
    gears(args)

def gears(args):
    lines = []
    grid = []
    totalratio = 0
    for line in args.input:
        lines.append(line.strip())
        grid.append(list(line.strip()))
    for y in range(len(grid)):
        for x in range(len(grid[y])):
            if grid[y][x] == "*":
                parts = selectsafe(grid, x, y)
                print(parts)
                if len(parts) == 2:
                    totalratio += parts[0]*parts[1]
    # print(grid)
    print(totalratio, file=args.output)

def allparts(args):
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
                # print(parts)
                for part in parts:
                    totalpart += part
                grid = newgrid
    # print(grid)
    print(totalpart, file=args.output)

def selectsafe(grid, x, y):
    parts = []
    # look above
    if y>0:
        if isnum(grid[y-1][x]):
            grid, parts = looksafe(grid, y-1, x, parts)
        else:
            if x>0 and isnum(grid[y-1][x-1]):
                grid, parts = looksafe(grid, y-1, x-1, parts)
            if x<(len(grid[0])-1) and isnum(grid[y-1][x+1]):
                grid, parts = looksafe(grid, y-1, x+1, parts)
    # looksafe left
    if x>0 and isnum(grid[y][x-1]):
        grid, parts = looksafe(grid, y, x-1, parts)
    # looksafe right
    if x<(len(grid[0])-1) and isnum(grid[y][x+1]):
        grid, parts = looksafe(grid, y, x+1, parts)
    # looksafe below
    if y<(len(grid)-1):
        if isnum(grid[y+1][x]):
            grid, parts = looksafe(grid, y+1, x, parts)
        else:
            if x>0 and isnum(grid[y+1][x-1]):
                grid, parts = looksafe(grid, y+1, x-1, parts)
            if x<(len(grid[0])-1) and isnum(grid[y+1][x+1]):
                grid, parts = looksafe(grid, y+1, x+1, parts)
    return parts

def select(grid, x, y):
    parts = []
    # look above
    if y>0:
        if isnum(grid[y-1][x]):
            grid, parts = look(grid, y-1, x, parts)
        else:
            if x>0 and isnum(grid[y-1][x-1]):
                grid, parts = look(grid, y-1, x-1, parts)
            if x<(len(grid[0])-1) and isnum(grid[y-1][x+1]):
                grid, parts = look(grid, y-1, x+1, parts)
    # look left
    if x>0 and isnum(grid[y][x-1]):
        grid, parts = look(grid, y, x-1, parts)
    # look right
    if x<(len(grid[0])-1) and isnum(grid[y][x+1]):
        grid, parts = look(grid, y, x+1, parts)
    # look below
    if y<(len(grid)-1):
        if isnum(grid[y+1][x]):
            grid, parts = look(grid, y+1, x, parts)
        else:
            if x>0 and isnum(grid[y+1][x-1]):
                grid, parts = look(grid, y+1, x-1, parts)
            if x<(len(grid[0])-1) and isnum(grid[y+1][x+1]):
                grid, parts = look(grid, y+1, x+1, parts)
    return grid, parts

def looksafe(grid, y, x, parts):
    num, _, _ = bounds(grid[y], x)
    parts.append(num)
    return grid, parts

def look(grid, y, x, parts):
    num, left, right = bounds(grid[y], x)
    clear(grid, y, left, right)
    parts.append(num)
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

