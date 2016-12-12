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
    y = 0 if y.nil?
    [type.to_sym, x.to_i, y.to_i]
end

def finished?(state)
    state[:idx] >= state[:commands].length
end

def evolve(state)
    state
end

def execute(state, instruction)

end

p function("input.txt")
