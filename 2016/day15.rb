require 'byebug'

def function(filename)
    File.open(filename, 'r') do |file|
        #file.read.strip
        discs = file.each.map do |line|
            /Disc #.* has (.*) positions; at time=0, it is at position (.*)\./.match(
                "Disc #1 has 5 positions; at time=0, it is at position 4."
            ).to_a[1..-1]
        end
        lcm = 1
        discs.map!.each_with_index do |pair, idx|
            cycle, position = pair.map(&:to_i)
            lcm *= cycle
            [cycle, (position + idx + 1) % cycle]
        end
        0.upto(lcm) do |idx|
            return idx if discs.all? { |pair| (pair[1] + idx) % pair[0] == 0 }
        end
    end
end

puts function("input.txt")
