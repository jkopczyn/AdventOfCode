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
    # total Rs in input ~900, total Ds ~900
    grid = [['.' for _ in range(12)] for _ in range(12)]
    # grid = [['.' for _ in range(900)] for _ in range(900)]
    coords = (0,0)
    for line in args.input:
        direction, distance, color = line.strip().split(" ")
        distance = int(distance)
        grid, coords = dig(grid, coords, direction, distance)
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

if __name__ == "__main__":
    main()

