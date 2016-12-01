require 'byebug'

def twisting_grid(filename)
  File.open(filename, 'r') do |file|
      commands = file.split(", ")
  end
  vector = (0, 1) #x, y
  position = (0, 0)
end

def parse_command(token)
    token.strip!
    {
        turn: token[0].to_sym,
        distance: token[1..-1].to_i
    }
end

def turn(vector, direction)
    if direction in [:right, :R, :r]
        (vector[1], -vector[0])
    elsif direction in [:left, :L, :l]
        (-vector[1], vector[0])
    end
end

puts twisting_grid("input.txt")
