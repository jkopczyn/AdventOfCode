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
    for line in args.input:
        print(line, score_hand(line.split(" ")[0]), file=args.output)

def score_hand(chars):
    cards = {}
    for c in chars:
        if c in cards:
            cards[c] += 1
        else:
            cards[c] = 1
    counts = sorted(cards.values(), reverse=True)
    first = counts[0]
    second = counts[1]
    if first == 1:
        score = 0
    elif first == 2 and second == 1:
        score = 10000000000
    elif first == 2 and second == 2:
        score = 20000000000
    elif first == 3 and second == 1:
        score = 30000000000
    elif first == 3 and second == 2:
        score = 40000000000
    elif first == 4:
        score = 50000000000
    elif first == 5:
        score = 60000000000
    else:
        raise Exception(chars +"invalid score")
    return score + tiebreaker(chars)

def tiebreaker(chars):
    s = ""
    for c in chars:
        if c in "123456789":
            s += "0"+c
        elif c == "T":
            s += "10"
        elif c == "J":
            s += "11"
        elif c == "Q":
            s += "12"
        elif c == "K":
            s += "13"
    return int(s)

if __name__ == "__main__":
    main()

