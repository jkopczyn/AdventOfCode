require 'byebug'
require 'set'

class Building_State
    def initialize(options)
        @floors = [1,2,3,4].map { |i| [i, Floor.new({number: i}) }.to_h
    end
end

class Floor
    attr_accessor :elevator, :number, :generators, :microchips
    def initialize(options)
        @elevator = options[:elevator] or false
        @generators = Set.new|options[:generators]
        @microchips = Set.new|options[:microchips]
        @number = options[:number]
    end

    def dup
        Floor.new({
            elevator: @elevator
            generators: @generators.dup
            microchips: @microchips.dup
            number: @number
        })
    end
end

def function(filename)
    File.open(filename, 'r') do |file|
        building = file.each_with_index.map do |line, idx|
            [1+idx, parse_line(line)]
        end.to_h
        building[1][:elevator] = true
        explore_solutions(building, Set.new)
    end
end

def duplicate(state)
    [1,2,3,4].map do |i|
        [i, { generator: state[i][:generator].dup,
              microchip: state[i][:microchip].dup,
              elevator: state[i][:elevator]
        }]
    end.to_h
end

def new_state(state, move)
    old_floor = state.each.select { |k, v| v[:elevator] }.map {|k,v| k }.first
    new_floor = old_floor + move[0]
    state[old_floor][:elevator], state[new_floor][:elevator] = false, true
    state = duplicate(state)
    move[1].each do |obj|
        state[old_floor][obj[0]].delete(obj[1])
        state[new_floor][obj[0]].add(obj[1])
    end
    state
end

def possible_moves(floor, directions=[1, -1])
    return [] if not floor[:elevator]
    objects = Set.new((floor[:generator].map {|v| [:generator, v] } +
        floor[:microchip].map {|v| [:microchip, v] }))
    subsets = Set.new(objects.map do |obj1|
        objects.map { |obj2| Set.new([obj1, obj2]) }
    end).inject(&:+)
    subsets.map do |subset|
        directions.map { |d| [d, subset] }.to_a
    end.inject(&:+)
end


def explore_solutions(building, history)
    return 0 if is_successful?(building)
    return false if is_unsafe?(building) or history.include?(building)
    history.add(building)
    p history.size
    debugger if history.size % 1024 == 0
    shortest = generate_moves(building).map do |move|
        explore_solutions(new_state(building, move), history)
    end.select {|v| v}.min
    shortest and (shortest + 1)
end

def generate_moves(building)
    building.keys.map do |key|
        case key
        when 1 then possible_moves(building[key], directions=[1])
        when 4 then possible_moves(building[key], directions=[-1])
        else possible_moves(building[key])
        end
    end.inject(&:+)
end

def is_successful?(building)
    building[4][:elevator] and [1,2,3].all? do |level|
        [:generator, :microchip].all? do |object|
            building[level][object].empty?
        end
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
