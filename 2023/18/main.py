#! /usr/bin/env python3
import sys
import argparse
import itertools

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
    # testinput is 10x12
    # grid = [['.' for _ in range(13)] for _ in range(12)]
    # total Rs in input ~900, total Ds ~900
    grid = [['.' for _ in range(900)] for _ in range(900)]
    coords = (1,1) # padding with empty row and col helps
    for line in args.input:
        direction, distance, color = line.strip().split(" ")
        distance = int(distance)
        grid, coords = dig(grid, coords, direction, distance)
    for row in grid:
        print(''.join(row), file=args.output)
    print(sum([len([x for x in row if x == '#']) for row in grid]))
    grid = fill(grid)
    for row in grid:
        print(''.join(row), file=args.output)
    print(sum([len([x for x in row if x == '#']) for row in grid]))

def dig(grid, coords, direction, distance):
    x, y = coords
    if direction == 'D':
        for newy in range(y+1, y+distance+1):
            grid[newy][x] = "#"
        return grid, (x, y+distance)
    elif direction == 'U':
        for newy in range(y-1, y-distance-1, -1):
            grid[newy][x] = "#"
        return grid, (x, y-distance)
    elif direction == 'R':
        for newx in range(x+1, x+distance+1):
            grid[y][newx] = "#"
        return grid, (x+distance, y)
    elif direction == 'L':
        for newx in range(x-1, x-distance-1, -1):
            grid[y][newx] = "#"
        return grid, (x-distance, y)

def fill(grid):
    # grid is padded with 1 empty row and col
    for y in range(1, len(grid)):
        row = grid[y]
        runs = row_to_runs(row)
        for run in runs:
            start, end, char = run
            if char == '#':
                continue
            above = grid[y-1][start:end+1]
            if all(c == '#' for c in above):
                for idx in range(start, end+1):
                    row[idx] = '#'
    return grid

def row_to_runs(row):
    runs = []
    idx = 0
    while idx < len(row)-1:
        row, idx, run = grab_run(row, idx)
        print(row, idx, run)
        runs.append(run)
    print(runs)
    return runs

def grab_run(row, idx):
    char = row[idx]
    run = list(itertools.takewhile(lambda c: c == char, row[idx:]))
    run_spec = (idx, idx+len(run)-1, char)
    return (row, idx+len(run), run_spec)

if __name__ == "__main__":
    main()

