def main():
    low  = 7500000
    high = 8000000
    highest = 35696887
    target = 213116810861248

    while high-low > 1:
        candidate = halfway(low, high)
        score = candidate * (highest - candidate)
        print(candidate, highest-candidate, score>target)
        if score > target:
            high = candidate
        else:
            low = candidate
    print("low:", low, "high:", high)
    print(low, highest-low, (low*(highest-low))>target)
    print(high, highest-high, (high*(highest-high))>target)

def halfway(x, y):
    return int((x+y)/2)

if __name__ == "__main__":
    main()

