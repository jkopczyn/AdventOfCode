require 'byebug'
require 'set'

def function(filename)
    File.open(filename, 'r') do |file|
        #file.read.strip
        file.each_with_index.map do |line, idx|
            [1+idx, parse_line(line)]
        end.to_h
    end
end

def parse_line(line)
    items = line.split(/contains|\./)[1].split(/,|and/).map(&:strip)
    floor = { generators: Set.new, chips: Set.new }
    return floor if items.first == "nothing relevant"
end

puts function("input.txt")
