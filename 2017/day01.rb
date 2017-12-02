require 'byebug'

def function(filename)
    File.open(filename, 'r') do |file|
        digits = file.read.strip.split('').map(&:to_i)
        selected_digits = digits.select.each_with_index do |el, idx|
            el == digits[idx-1]
        end
        return selected_digits.inject(&:+)
    end
end

puts function("input01.txt")
