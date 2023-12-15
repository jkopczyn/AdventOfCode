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
    galaxies = []
    xs = {}
    ys = {}
    y = 0
    for line in args.input:
        ys[y] = False
        for idx in range(len(line)):
            if idx not in xs:
                xs[idx] = False
            if line[idx] == "#":
                xs[idx] = True
                ys[y] = True
                galaxies.append((idx, y))
        y += 1
    blank_xs = list(x for x in xs if not xs[x])
    blank_ys = list(y for y in ys if not ys[y])

    extra_xs = [0]*len(xs)
    for x in blank_xs:
        for idx in range(x,len(xs)):
            extra_xs[idx] += (1000000 - 1)
    xs_old_to_new = list(idx + extra_xs[idx] for idx in range(len(xs)))

    extra_ys = [0]*len(ys)
    for y in blank_ys:
        for idx in range(y,len(ys)):
            extra_ys[idx] += (1000000 - 1)
    ys_old_to_new = list(idx + extra_ys[idx] for idx in range(len(ys)))

    new_galaxies = list((xs_old_to_new[g[0]], ys_old_to_new[g[1]]) for g in galaxies)
    # print(new_galaxies, file=args.output)
    total_distance = 0
    for idx in range(len(new_galaxies)):
        g = new_galaxies[idx]
        for jdx in range(idx+1, len(new_galaxies)):
            h = new_galaxies[jdx]
            distance = abs(g[0]-h[0])+abs(g[1]-h[1])
            total_distance += distance
    print(total_distance, file=args.output)
 

if __name__ == "__main__":
    main()

