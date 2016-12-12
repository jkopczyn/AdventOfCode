require 'byebug'

def function(filename)
    state = {}
    File.open(filename, 'r') do |file|
        commands = file.map { |line| parse(line) }
        state = {a: 0, b: 0, c: 1, d:0, commands: commands, idx: 0}
        until finished?(state)
            evolve(state)
        end
    end
    state
end

def parse(command)
    type, x, y = command.split
    y = 1 if y.nil?
    [type.to_sym, sym_or_num(x), sym_or_num(y)]
end

def sym_or_num(symbol)
    return symbol.to_i if /[0-9]+/.match(symbol)
    symbol.to_sym
end

def finished?(state)
    p state[:commands][state[:idx]]
    state[:idx] >= state[:commands].length
end

def evolve(state)
    instruction = state[:commands][state[:idx]]
    state = execute(state, instruction)
    state[:idx] += 1
    state
end

def dereference(state, v)
    state.has_key?(v) ? state[v] : v
end

def execute(state, instruction)
    case instruction[0]
    when :inc
        state[instruction[1]] += dereference(state, instruction[2])
    when :dec
        state[instruction[1]] -= dereference(state, instruction[2])
    when :cpy
        state[instruction[2]] = dereference(state, instruction[1])
    when :jnz
        _, condition, offset = instruction
        if dereference(state, condition) != 0
            state[:idx] += dereference(state, offset) - 1
        end
    end
    state
end

p function("input12.txt")
