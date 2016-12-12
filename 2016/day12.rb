require 'byebug'

def function(filename)
    File.open(filename, 'r') do |file|
        #file.read.strip
        commands = file.map do |line|
            parse(line)
        end
        state = {registers: {a: 0, b: 0, c: 0, d:0}, commands: commands, idx: 0}
        until finished?(state)
            state = evolve(state)
        end
    end
    state
end

def parse(command)
    type, x, y = line.split
end

def finished?(state)
    state[:idx] >= state[:commands].length
end

def evolve(state)

end

def execute(state, instruction)

end

p function("input.txt")
