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

    patterns = []
    pattern = []
    for line in args.input:
        if line.strip() == "":
            patterns.append(pattern)
            pattern = []
            continue
        pattern.append(line.strip())
    patterns.append(pattern)

    score = 0
    smudge_score = 0
    for pattern in patterns:
        row_splits = []
        print("rows")
        for row in pattern:
            row_splits.append(set(line_mirrored_splits(row)))
        good_row = normal_intersect(row_splits)
        smudge_row = smudge_intersect(row_splits)
        print(good_row, smudge_row, file=args.output)
        col_splits = []
        print("columns")
        for idx in range(len(row)):
            col = list(r[idx] for r in pattern)
            col_splits.append(set(line_mirrored_splits(col)))
        good_col = normal_intersect(col_splits)
        smudge_col = smudge_intersect(col_splits)
        print(good_col, smudge_col, file=args.output)
        for c in smudge_col:
            smudge_score += 100*c
        for r in smudge_row:
            smudge_score += r
        for c in good_col:
            score += 100*c
        for r in good_row:
            score += r
        if not good_col and not good_row:
            print(row_splits, col_splits)
            print(pattern)
            raise Exception("no lines of reflection")
    print(score, smudge_score, file=args.output)

def normal_intersect(sets):
    return set.intersection(*sets)

def smudge_intersect(sets):
    all_but_ones = list(
            list(sets[i] for i in range(len(sets)) if i != j)
            for j in range(len(sets))
            )
    all_but_intersects = list(set.intersection(*ss) for ss in all_but_ones)
    smudge_line = set.union(*all_but_intersects) - normal_intersect(sets)
    print(all_but_intersects, smudge_line)
    return smudge_line

def line_mirrored_splits(line):
    splits = []
    for split in range(1,len(line)):
        step = 1
        mirrored = True
        while step <= split and split+step <= len(line):
            if line[split-step] != line[split+step-1]:
                mirrored = False
                break
            step += 1
        if mirrored:
            splits.append(split)
    return splits


if __name__ == "__main__":
    main()

