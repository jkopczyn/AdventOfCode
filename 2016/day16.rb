require 'byebug'

def function(seed, size)
    seed = seed.chars.map {|c| c == '1'}
    result = checksum(fill(seed, size))
    p result
    result.map { |el| el ? 1 : 0 }.join
end

def fill(seed, size)
    while seed.size < size
        seed += [false] + seed.map(&:!).reverse
    end
    seed[0...size]
end

def checksum(data)
    while data.size % 2 == 0
        data = (data.size/2).times.map do |idx|
            data[2*idx] == data[2*idx+1]
        end
    end
    data
end

puts function("11100010111110100", 272)
puts function("11100010111110100", 35651584)
