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

puts function("input.txt")
 
