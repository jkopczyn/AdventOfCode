require 'byebug'

def function(filename, offset=false)
    File.open(filename, 'r') do |file|
        buckets = file.read.strip.split.map(&:to_i)
        states = {}
        i = 0
        while(true)
            state = buckets.join(' ')
            if states[state]
                if offset
                    return i - states[state]
                end
                return i
            end
            states[state] = i
            i += 1
            idx = highest_value_index(buckets)
            value = buckets[idx]
            buckets[idx] = 0
            while value > 0
                idx = (idx + 1) % buckets.length
                buckets[idx] += 1
                value -= 1
            end
        end
    end
end

def highest_value_index(list)
    max = list.max
    list.index { |el| el == max }
end

puts function("input.txt")
puts function("input06.txt")
puts function("input.txt", true)
puts function("input06.txt", true)
