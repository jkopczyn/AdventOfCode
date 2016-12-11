require 'byebug'
require 'set'

def function(filename)
    File.open(filename, 'r') do |file|
        building = file.each_with_index.map do |line, idx|
            [1+idx, parse_line(line)]
        end.to_h
        building[1][:elevator] = true
        explore_solutions(building)
    end
end

def possible_moves(floor, directions=[1, -1])
    return [] if not floor[:elevator]
    objects = Set.new((floor[:generator].map {|v| Set.new([:generator, v]) } +
        floor[:microchip].map {|v| Set.new([:microchip, v]) }))
    one_object = objects.map do |obj|
        directions.map { |d| [d, obj] }
    end.inject([], &:+)
end

def explore_solutions(building)
    building.keys.map do |key|
        next if is_unsafe?(building)
        possible_moves(building[key])
    end
end

def is_unsafe?(building)
    building.values.any? { |floor| not chips_safe?(floor) }
end

def chips_safe?(floor)
    floor[:microchip].empty? or ((floor[:generator] - floor[:microchip]).empty?)
end

def parse_line(line)
    items = line.split(/contains|\./)[1].split(/,|and/).map(&:strip)
    floor = { generator: Set.new, microchip: Set.new, elevator: false }
    return floor if items.first == "nothing relevant"
    items.each do |item|
        _,  element, thing = item.split
        element, thing = element.split('-')[0].to_sym, thing.to_sym
        floor[thing].add(element)
    end
    floor
end

p function("input.txt")
