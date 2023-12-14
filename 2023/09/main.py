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
    old, new = 0, 0
    for line in args.input:
        lst = list(int(x.strip()) for x in line.split(" "))
        first, last = differences(lst)
        old += first
        new += last
        print(first, last)
    print(old, new, file=args.output)

def differences(lst):
    lasts = [lst[-1]]
    firsts = [lst[0]]
    layer = lst
    while not matching(layer):
        left = layer[0]
        new_layer = []
        for right in layer[1:]:
            new_layer.append(right-left)
            left = right
        layer = new_layer
        firsts.append(layer[0])
        lasts.append(layer[-1])
    # print(lasts)
    return (reconstruct(firsts), sum(lasts))

def reconstruct(lst):
    start = lst[-1]
    nxt = start
    for x in list(reversed(lst))[1:]:
        nxt = x - nxt
    return nxt

def matching(lst):
    first = lst[0]
    return all(x == first for x in lst)

if __name__ == "__main__":
    main()

