require 'byebug'

def function(filename)
    state = {}
    File.open(filename, 'r') do |file|
        #file.read.strip
        commands = file.map { |line| parse(line) }
        state = {a: 0, b: 0, c: 0, d:0, commands: commands, idx: 0}
        until finished?(state)
            evolve(state)
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
    #p state, state[:idx], state[:commands][state[:idx]]
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
        state[instruction[1]] += 1
    when :dec
        state[instruction[1]] -= 1
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
