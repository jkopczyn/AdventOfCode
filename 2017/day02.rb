require 'byebug'

def lineloop(filename, method)
    File.open(filename, 'r') do |file|
        return (file.each.map do |line|
            method.call(line.split.map(&:to_i))
        end.inject(&:+))
    end
end

def maxmin(nums)
    return nums.max - nums.min
end


def divides(nums)
    nums.sort!
    nums.each_with_index do |el, idx|
        (idx+1).upto(nums.length-1) do |jdx|
            return nums[jdx]/el if (nums[jdx]%el == 0)
        end
    end
end

puts lineloop("input02.txt", method(:maxmin))
puts lineloop("input02.txt", method(:divides))
