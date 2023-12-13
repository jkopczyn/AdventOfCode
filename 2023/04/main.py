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
    totalscore = 0
    for line in args.input:
        card, nums = line.split(":")
        wlist, plist = nums.strip().split("|")
        winners= wlist.strip().split(" ")
        picks = plist.strip().split(" ")
        s = score(winners, picks)
        print(s)
        totalscore += s
    print(totalscore, file=args.output)

def score(wins, picks):
    s = 0
    for p in picks:
        if p in wins:
            if s == 0:
                s = 1
            else:
                s *= 2
    return s

if __name__ == "__main__":
    main()

