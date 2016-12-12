require 'byebug'

def function(filename)
    state = {}
    File.open(filename, 'r') do |file|
        #file.read.strip
        commands = file.map { |line| parse(line) }
        state = {registers: {a: 0, b: 0, c: 0, d:0}, commands: commands, idx: 0}
        until finished?(state)
            state = evolve(state)
        end
    end
    state
end

def parse(command)
    type, x, y = command.split
    type = type.to_sym
    if [:inc, :dec].include?(type)
        [type, x.to_sym, 0]
    elsif type == :cpy
        [type, sym_or_num(x), y.to_sym]
    else
        [type, sym_or_num(x), sym_or_num(y)]
    end
end

def sym_or_num(symbol)
    return symbol.to_i if /[0-9]+/.match(symbol)
    symbol.to_sym
end

def finished?(state)
    state[:idx] >= state[:commands].length
end

def evolve(state)
    state = execute(state, state[:commands][state[:idx]])
    state[:idx] += 1
    state
end

def execute(state, instruction)
    state
end

p function("input.txt")
