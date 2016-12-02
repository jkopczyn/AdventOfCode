require 'byebug'

CENTER = [1,1]

def function(filename)
  File.open(filename, 'r') do |file|
      location = [0,0]
      diamond_center = [2, 0]
      file.map do |line|
          moves = line.strip.split('')
          location = chain_moves(moves, location, diamond_center)
          location_to_number(location, diamond_center)
      end.join('')
  end
end

def chain_moves(moves, location, center=CENTER)
    current_location = location
    moves.each do |move|
        vector = decode_movement(move)
        next_location = [
            vector[0]+current_location[0],
            vector[1]+current_location[1]
        ]
        unless out_of_bounds?(relativize(next_location, center))
            current_location = next_location 
        end
    end
    current_location
end

def decode_movement(token)
    case token
    when 'U' then [0,1]
    when 'D' then [0,-1]
    when 'L' then [-1,0]
    when 'R' then [1,0]
    else raise "Argument Error"
    end
end

def relativize(location, center)
    [(location[0] - center[0]), (location[1] - center[1])]
end

def out_of_bounds?(relative_location)
    relative_location.map(&:abs).inject(&:+) > 2
end

def location_to_number(location, center=CENTER)
    relative_x, relative_y = relativize(location, center)
    raise "Out Of Bounds Exception" if out_of_bounds?([relative_x, relative_y])
    case relative_y
    when 0 then (7 + relative_x).to_s
    when 1 then (3 + relative_x).to_s
    when 2 then 1
    when -1 then ['A','B','C'][relative_x+1]
    when -2 then 'D'
    end
end

puts function("input02.txt")
 
