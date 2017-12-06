require 'byebug'

def function(filename, threshold=nil)
    File.open(filename, 'r') do |file|
        jumps = file.each.map(&:to_i)
        i = 0
        steps = 0
        while i >= 0 and i < jumps.length
            j = i + jumps[i]
            if threshold and jumps[i] >= threshold
                jumps[i] -= 1
            else
                jumps[i] += 1
            end
            i = j
            steps += 1
        end
        p jumps
        return steps
    end
end

puts function("input.txt")
puts function("input.txt", threshold=3)
puts function("input05.txt")
puts function("input05.txt", threshold=3)
