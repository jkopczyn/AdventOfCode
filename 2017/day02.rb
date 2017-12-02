require 'byebug'

def function(filename)
    File.open(filename, 'r') do |file|
        return (file.each.map do |line|
            numbers = line.split.map(&:to_i)
            numbers.max - numbers.min
        end.inject(&:+))
    end
end

puts function("input02.txt")
