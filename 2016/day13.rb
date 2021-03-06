require 'byebug'

###What follows comes from https://github.com/Pommespanzer
class Astar

    def initialize(start, destination, map)
        # create start and destination nodes
        @map = map
        @start_node = Astar_Node.new(start[:x], start[:y], -1, -1, -1, -1)
        @dest_node  = Astar_Node.new(destination[:x], destination[:y], -1, -1, -1, -1)

        @open_nodes   = [] # contains all open nodes (nodes to be inspected)
        @closed_nodes = [] # contains all closed nodes (node we've already inspected)

        @open_nodes.push(@start_node) # push the start node
    end

    # calc heuristic
    def heuristic(current_node, destination_node)
        return ((current_node.x - destination_node.x) +
                (current_node.y - destination_node.y))
    end

    # calc cost
    def cost(current_node, destination_node)
        direction = direction(current_node, destination_node)

        return 10 if [2, 4, 6, 8].include?(direction) # south, west, east, north
        raise WTF
    end

    # determine direction (2, 4, 6, 8)
    def direction(current_node, destination_node)
        direction = [ destination_node.y - current_node.y,  # down/up
                      destination_node.x - current_node.x ] # negative: left, positive: right

        return 2 if direction[0] > 0 and direction[1] == 0 # south
        return 4 if direction[1] < 0 and direction[0] == 0 # west
        return 8 if direction[0] < 0 and direction[1] == 0 # north
        return 6 if direction[1] > 0 and direction[0] == 0 # east

        return 0 # default
    end

    # field passable?
    def passable?(x, y)
        return @map[[x,y]]
    end

    # expand node in all 4 directions
    def expand(current_node)
        x   = current_node.x
        y   = current_node.y

        return [ [x, (y - 1)],  # north
                 [x, (y + 1)],  # south
                 [(x + 1), y],  # east
                 [(x - 1), y] ] # west
    end

    def search
        while @open_nodes.size > 0 do
            # grab the lowest f(x)
            low_i = 0
            for i in 0..@open_nodes.size-1
                if @open_nodes[i].f < @open_nodes[low_i].f then
                    low_i = i
                end
            end
            best_node = low_i

            # set current node
            current_node = @open_nodes[best_node]

            # check if we've reached our destination
            if (current_node.x == @dest_node.x) and (current_node.y == @dest_node.y) then
                path = [@dest_node]

                # recreate the path
                while current_node.i != -1 do
                    current_node = @closed_nodes[current_node.i]
                    path.unshift(current_node)
                end

                return path
            end

            # remove the current node from open node list
            @open_nodes.delete_at(best_node)

            # and push onto the closed nodes list
            @closed_nodes.push(current_node)

            # expand the current node
            neighbor_nodes = expand(current_node)
            for n in 0..neighbor_nodes.size-1
                neighbor = neighbor_nodes[n]
                nx       = neighbor[0]
                ny       = neighbor[1]

                # if the new node is passable or our destination
                if (passable?(nx, ny) or (nx == @dest_node.x and ny == @dest_node.y)) then
                    # check if the node is already in closed nodes list
                    in_closed = false
                    for j in 0..@closed_nodes.size-1
                        closed_node = @closed_nodes[j]
                        if nx == closed_node.x and ny == closed_node.y then
                            in_closed = true
                            break
                        end
                    end
                    next if in_closed

                    # check if the node is in the open nodes list
                    # if not, use it!
                    in_open = false
                    for j in 0..@open_nodes.size-1
                        open_node = @open_nodes[j]
                        if nx == open_node.x and ny == open_node.y then
                            in_open = true
                            break
                        end
                    end

                    unless in_open then
                        new_node = Astar_Node.new(nx, ny, @closed_nodes.size-1, -1, -1, -1)

                        # setup costs
                        new_node.set_g(current_node.g + cost(current_node, new_node))
                        new_node.set_h(heuristic(new_node, @dest_node))
                        new_node.set_f(new_node.g + new_node.h)

                        @open_nodes.push(new_node)
                    end
                end
            end
        end

        return [] # return empty path
    end

end

# Astar node representation
class Astar_Node

    # x = x-position
    # y = y-position
    # i = parent index
    # g = cost from start to current node
    # h = cost from current node to destination
    # f = cost from start to destination going through the current node
    def initialize(x, y, i, g, h, f)
        @x = x
        @y = y
        @i = i
        @g = g
        @h = h
        @f = f
    end

    def x
        return @x
    end

    def y
        return @y
    end

    def i
        return @i
    end

    def g
        return @g
    end

    def h
        return @h
    end

    def f
        return @f
    end

    def set_g g
        @g = g
    end

    def set_h h
        @h = h
    end

    def set_f f
        @f = f
    end

end

#what follows in my original code
def part1(favorite_number, target)
    map = make_map(favorite_number, target)
    answer = a_star(map, [1,1], target)
end

def part2(favorite_number, steps)
    map = make_map(favorite_number, [(steps+1)/2, (steps+1)/2])
    walked = dfs(map, [1,1], steps)
    count(walked)
end

def make_map(favorite_number, target)
    x, y = target
    map = {}
    (x*2).times do |h|
        (y*2).times do |v|
            value = h*h+3*h+2*h*v+v+v*v + favorite_number
            map[[h,v]] = (binary_ones(value) %2 == 0)
        end
    end
    map
end

def a_star(map, source, dest)
    find = Astar.new({x: source[1], y: source[1]},
                     {x: dest[0], y: dest[1]},
                     map
                    )
    result = find.search.size - 1
end

def binary_ones(number)
    count = 0
    while number > 0
        unless number % 2 == 0
            count += 1
            number -= 1
        end
        number /= 2
    end
    count
end

def dfs(map, start, depth)
    return map if depth < 0
    x, y = start[0], start[1]
    map[[x,y]] = depth
    [[x+1, y], [x, y+1], [x-1, y], [x,y-1]].each do |pair|
        h, v = pair
        next if h<0 or v<0
        if map[pair]
            unless map[pair].is_a?(Integer) and map[pair] >= depth
                dfs(map, pair, depth-1)
            end
        end
    end
    return map
end

def count(map)
    map.values.select {|el| el.is_a?(Integer) }.length
end


puts part1(1358, [31,39])
puts part2(1358, 50)
