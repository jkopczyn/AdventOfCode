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
    idsum = 0
    for line in args.input:
        game, pulls = line.split(":")
        if valid(maximum(pulls)):
            print(getgame(game), file=args.output)
            idsum += int(getgame(game))
    print(idsum, file=args.output)

def valid(result):
    r, g, b = result["r"], result["g"], result["b"]
    return(r <= 12 and g <= 13 and b <= 14)

def getgame(s):
    return s[-1]

def digest(draws):
    r, g, b = 0, 0 , 0
    for draw in draws:
        _, n, label = draw.split(" ")
        if label == "red":
            r += int(n)
        elif label == "green":
            g += int(n)
        elif label == "blue":
            b += int(n)
    return r, g, b

def maximum(pulls):
    ts = {"r": 0, "g": 0, "b": 0}
    for pull in pulls.split(";"):
        draws = pull.split(",")
        r, g, b = digest(draws)
        ts["r"] = max(r, ts["r"])
        ts["g"] = max(g, ts["g"])
        ts["b"] = max(b, ts["b"])
    return ts

#  Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
if __name__ == "__main__":
    main()

