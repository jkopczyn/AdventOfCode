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
    initial = args.input.readline().strip()
    commands = initial.split(",")
    total = 0
    for comm in commands:
        print(comm, xhash(comm), file=args.output)
        total += xhash(comm)
    print(total,  file=args.output)

def xhash(string):
    n = 0
    for c in string:
        n += ord(c)
        n = (n*17)%256
    return n

if __name__ == "__main__":
    main()

