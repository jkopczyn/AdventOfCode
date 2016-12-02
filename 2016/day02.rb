require 'byebug'

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

def location_to_number(location, center=[1,1])
    x, y = location
    relative_x, relative_y = (x - center[0]), (y - center[0])
    if relative_x.abs > 1 or relative_y.abs > 1
        raise "Out Of Bounds Exception"
    end
    case [relative_x, relative_y]
    when [-1, -1] then 1
    when [0, -1]  then 2
    when [1, -1]  then 3
    when [-1, 0]  then 4
    when [0, 0]   then 5
    when [1, 0]   then 6
    when [-1, 1]  then 7
    when [0, 1]   then 8
    when [1, 1]   then 9
    end

end

puts function("input.txt")
 
