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
        lst = list(int(x.strip()) for x in line.split(" "))
        sm = differences(lst)
        total += sm
        print(sm)
    print(total, file=args.output)

def differences(lst):
    lasts = [lst[-1]]
    layer = lst
    while not matching(layer):
        left = layer[0]
        new_layer = []
        for right in layer[1:]:
            new_layer.append(right-left)
            left = right
        layer = new_layer
        lasts.append(layer[-1])
    # print(lasts)
    return sum(lasts)

def matching(lst):
    first = lst[0]
    return all(x == first for x in lst)

if __name__ == "__main__":
    main()

