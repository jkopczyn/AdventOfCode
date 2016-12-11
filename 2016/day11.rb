require 'byebug'
require 'set'

def function(filename)
    File.open(filename, 'r') do |file|
        building = file.each_with_index.map do |line, idx|
            [1+idx, parse_line(line)]
        end.to_h
        explore_solutions(building)
    end
end

def explore_solutions(building)
    [1].each do
        next if is_unsafe?(building)
    end
    building
end

def is_unsafe?(building)
    building.values.any? { |floor| not chips_safe?(floor) }
end

def chips_safe?(floor)
    floor[:microchip].empty? or ((floor[:generator] - floor[:microchip]).empty?)
end

def parse_line(line)
    items = line.split(/contains|\./)[1].split(/,|and/).map(&:strip)
    floor = { generator: Set.new, microchip: Set.new }
    return floor if items.first == "nothing relevant"
    items.each do |item|
        _,  element, thing = item.split
        element, thing = element.split('-')[0].to_sym, thing.to_sym
        floor[thing].add(element)
    end
    floor
end

puts function("input.txt")
