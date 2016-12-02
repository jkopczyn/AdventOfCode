require 'byebug'

CENTER = [1,1]

def function(filename)
  File.open(filename, 'r') do |file|
      locations = [[1,1]]
      file.map do |line|
          moves = line.strip.split('')
          locations.push(chain_moves(moves, locations[-1]))
          location_to_number(locations[-1])
      end
  end
end

def chain_moves(moves, location, center=CENTER)

end

def location_to_number(location, center=CENTER)
    x, y = location
    relative_x, relative_y = (x - center[0]), (y - center[0])
    unless [-1, 0, 1].include?(relative_x.abs) and [-1, 0, 1].include?(relative_y.abs)
        raise "Out Of Bounds Exception"
    end
    5 + relative_x + 3*relative_y
end

puts function("input.txt")
 
