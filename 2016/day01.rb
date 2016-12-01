require 'byebug'

def twisting_grid(filename)
    File.open(filename, 'r') do |file|
        commands = file.read.split(", ")
        vector = [0, 1] #x, y
        position = [0, 0]
        commands.each do |token|
            results = parse_command(token)
            vector = turn(vector, results[:turn])
            position = advance(position, vector, results[:distance])
            puts "#{token} brings us to #{position}"
        end
        position[0].abs + position[1].abs
    end
end

def advance(position, vector, distance)
    [position[0] + vector[0]*distance, position[1] + vector[1]*distance]
end

def parse_command(token)
    token.strip!
    {
        turn: token[0].to_sym,
        distance: token[1..-1].to_i
    }
end

def turn(vector, direction)
    if([:right, :R, :r].include?(direction))
        [vector[1], -vector[0]]
    elsif([:left, :L, :l].include?(direction))
        [-vector[1], vector[0]]
    end
end

puts twisting_grid("input01.txt")
