require 'byebug'
require 'set'

def twisting_grid(filename)
    File.open(filename, 'r') do |file|
        commands = file.read.split(", ")
        vector = [0, 1] #x, y
        position = [0, 0]
        history = Set.new([position.to_s])
        commands.each do |token|
            position, vector, history, stop = 
                move_with_memory(position, vector, token, history)
            #puts "#{token} brings us to #{position}"
            if(stop)
                break
            end
        end
        p position
        position[0].abs + position[1].abs
    end
end

def move(position, vector, token)
    results = parse_command(token)
    vector = turn(vector, results[:turn])
    position = advance(position, vector, results[:distance])
    [position, vector]
end

def move_with_memory(position, vector, token, history)
    results, stop = parse_command(token), false
    newvec = turn(vector, results[:turn])
    newpos = advance(position, newvec, results[:distance])
    1.upto(results[:distance]) do |i|
        step = advance(position, newvec, i)
        if history.include?(step.to_s)
            stop = true
            newpos = step
            break
        end
        history.add(step.to_s)
    end
    [newpos, newvec, history, stop]
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
