require 'byebug'

def function(filename, offset=nil)
    File.open(filename, 'r') do |file|
        digits = file.read.strip.split('').map(&:to_i)
        unless offset
             offset = digits.length/2
        end
        selected_digits = digits.select.each_with_index do |el, idx|
            el == digits[idx-offset]
        end
        return selected_digits.inject(&:+)
    end
end

puts function("input01.txt", 1)
puts function("input01.txt")
