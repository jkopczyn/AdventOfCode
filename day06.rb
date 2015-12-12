def best_lights(filename)
  grid_lit = Array.new(1000) { Array.new(1000) { false } }
  File.open(filename, 'r') do |file|
    file.each do |line|
      words = line.split()
      coords2 = words.pop.split(",").map(&:to_i)
      words.pop
      coords1 = words.pop.split(",").map(&:to_i)
      command = words.join(" ")
      standardize_pairs(coords1, coords2)
      (coords1[1]..coords2[1]).each do |y|
        (coords1[0]..coords2[0]).each do |x|
          case command 
          when "turn on"
            grid_lit[y][x] = true
          when "turn off"
            grid_lit[y][x] = false
          when "toggle"
            grid_lit[y][x] = !grid_lit[y][x]
          end
        end
      end
    end
  end
  grid_lit.flatten.select {|lit| lit}.length
end

def better_lights(filename)
  grid_lit = Array.new(1000) { Array.new(1000) { 0 } }
  File.open(filename, 'r') do |file|
    file.each do |line|
      words = line.split()
      coords2 = words.pop.split(",").map(&:to_i)
      words.pop
      coords1 = words.pop.split(",").map(&:to_i)
      command = words.join(" ")
      standardize_pairs(coords1, coords2)
      (coords1[1]..coords2[1]).each do |y|
        (coords1[0]..coords2[0]).each do |x|
          case command 
          when "turn on"
            grid_lit[y][x] += 1
          when "turn off"
            grid_lit[y][x] -= 1 if grid_lit[y][x] > 0
          when "toggle"
            grid_lit[y][x] += 2
          end
        end
      end
    end
  end
  grid_lit.flatten.inject(&:+)
end

def standardize_pairs(first, second)
  x1, y1 = first
  x2, y2 = second
  first[0], second[0] =  [x1, x2].sort
  first[1], second[1] =  [y1, y2].sort
end

puts best_lights("input6.txt")
puts better_lights("input6.txt")
