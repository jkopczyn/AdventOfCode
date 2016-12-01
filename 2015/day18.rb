require 'byebug'

def life_lights(filename, steps)
  light_array = []
  File.open(filename, 'r') do |file|
    file.each do |line|
      light_array.push(line.strip.split('').map {|c| c == '#'})
    end
  light_array[0][0] = true
  light_array[0][-1] = true
  light_array[-1][-1] = true
  light_array[-1][0] = true
  end
  pretty_grid(light_array)
  steps.times do 
    #pretty_grid(light_array)
    light_array = evolve(light_array)
  end
  pretty_grid(light_array)
  light_array.map {|line| line.count {|b| b} }.inject(&:+)
end

def evolve(light_grid)
  new_grid = []
  light_grid.each_with_index do |line, y|
    new_grid.push(line.each_with_index.map do |pixel, x|
      neighbor_locs = neighbors([y,x], light_grid.count, light_grid[0].count)
      lit_neighbors = neighbor_locs.map do |posn|
        light_grid[posn[0]][posn[1]]
      end.count {|b| b}
      lit_neighbors == 3 or (pixel and lit_neighbors == 2)
    end)
  end
  new_grid[0][0] = true
  new_grid[0][-1] = true
  new_grid[-1][-1] = true
  new_grid[-1][0] = true
  new_grid
end

def neighbors(posn, height, width)
  [[-1, -1], [-1, 0], [-1, 1], [0, -1], 
   [0, 1], [1, -1], [1, 0], [1, 1]].map do |vector|
    [posn[0]+vector[0],posn[1]+vector[1]]
  end.select do |loc|
    y, x = loc
    0 <= y and y < height and 0 <= x and x < width
  end
end

def pretty_grid(light_grid)
  puts (light_grid.map do |line|
    line.map { |pixel| pixel ? '#' : '.' }.join('')
  end).join("\n")
  puts "\n"
end

puts life_lights("testinput18.txt", 5)
puts life_lights("input18.txt", 100)
