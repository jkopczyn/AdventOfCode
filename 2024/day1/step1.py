def read_input(filename):
    numbers = []
    with open(filename, 'r') as file:
        for line in file:
            # Split line on spaces and convert each element to int
            numbers.append([int(x) for x in line.strip().split()])
    return numbers

pairs = read_input("testinput.txt")

xs = sorted([x for x, y in pairs])
ys = sorted([y for x, y in pairs])

diffs = [abs(xs[i] - ys[i]) for i in range(len(xs))]
print(diffs)
print(sum(diffs))