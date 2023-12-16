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
    boxes = [list() for _ in range(256)]
    for comm in commands:
        if "-" in comm:
            label, _ = comm.split("-")
            remove(boxes, xhash(label), label)
        elif "=" in comm:
            label, num = comm.split("=")
            if contains(boxes, xhash(label), label):
                mutate(boxes, xhash(label), label, num)
            else:
                add(boxes, xhash(label), label, num)
    total_power = 0
    for idx in range(len(boxes)):
        b = boxes[idx]
        if len(b) > 0:
            this_power = focusing_power(boxes, idx)
            total_power += this_power
            print(b, this_power, file=args.output)
    print(total_power, file=args.output)


def focusing_power(boxes, idx):
    power = 0
    for jdx in range(len(boxes[idx])):
        lens = int(boxes[idx][jdx][1])
        power += (jdx+1)*lens
    return power*(idx+1)

def remove(boxes, position, label):
    for idx in range(len(boxes[position])):
        l, _ = boxes[position][idx]
        if l == label:
            boxes[position] = boxes[position][:idx] + boxes[position][idx+1:]
            return

def mutate(boxes, position, label, num):
    for idx in range(len(boxes[position])):
        l, _ = boxes[position][idx]
        if l == label:
            boxes[position][idx] = (label, num)
            return

def contains(boxes, position, label):
    for l, n in boxes[position]:
        if l == label:
            return True
    return False

def add(boxes, position, label, num):
    boxes[position].append((label, num))


def xhash(string):
    n = 0
    for c in string:
        n += ord(c)
        n = (n*17)%256
    return n

if __name__ == "__main__":
    main()

