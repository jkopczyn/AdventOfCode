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
    floor = { generator: Set.new, microchip: Set.new }
    return floor if items.first == "nothing relevant"
    items.each do |item|
        element, thing = element.split('-')[0].to_sym, thing.to_sym
        floor[thing].add(element)
    end
    floor
end

puts function("input.txt")
