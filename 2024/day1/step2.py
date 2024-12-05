def read_input(filename):
    numbers = []
    with open(filename, 'r') as file:
        for line in file:
            # Split line on spaces and convert each element to int
            numbers.append([int(x) for x in line.strip().split()])
    return numbers

pairs = read_input("testinput.txt")

count_map = {}
for _, y in pairs:
    count_map[y] = count_map.get(y, 0) + 1

print(count_map)

total = 0
for x, _ in pairs:
    total += count_map.get(x, 0)*x

print(total)