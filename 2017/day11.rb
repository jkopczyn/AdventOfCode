require 'byebug'

def function(filename, history=false)
    File.open(filename, 'r') do |file|
        moves = file.read.strip.split(',').each.map do |dir|
            map_to_coords(dir)
        end
        if not history
            space = moves.inject {|c,d| coord_add(c,d) }
            return shortest_path(space)
        else
            space = [0,0]
            far   = 0
            moves.each do |move|
                space = coord_add(space, move)
                far = [far, shortest_path(space)].max
            end
            return far
        end
    end
end

def coord_add(c1, c2)
    c1.length.times.map { |n| c1[n] + c2[n] }
end

def map_to_coords(dir)
    #[a,b]: +n, +ne
    {'n' =>  [ 1,0], 'ne' =>  [0, 1], 'se' =>  [-1, 1],
     's' =>  [-1,0], 'sw' =>  [0,-1], 'nw' =>  [ 1,-1]}[dir]
end

def shortest_path(space)
    dir1 = space[0].abs + space[1].abs
    dir2 = space[0].abs + coord_add(space, [-space[0], space[0]])[1].abs
    dir3 = space[1].abs + coord_add(space, [space[1], -space[1]])[0].abs
    [dir1, dir2, dir3].min
end
puts function("input.txt")
puts function("input11.txt")
puts function("input.txt", history=true)
puts function("input11.txt", history=true)
