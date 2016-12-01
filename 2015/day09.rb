require 'set'

def traveling_santa(filename)
  distance_map = Hash.new {|h, k| h[k] = Hash.new }
  locations = Set.new
  File.open(filename, 'r') do |file|
    file.each do |line|
      loc_string, distance = line.strip.split(" = ")
      distance = distance.to_i
      loc1, loc2 = loc_string.split("to").map {|str| str.strip.to_sym }
      distance_map[loc1][loc2] = distance
      distance_map[loc2][loc1] = distance
      locations += [loc1, loc2]
    end
  end
  locations.to_a.permutation.map do |p|
    (p.each_with_index.map do |el, idx|
      if idx == 0
        distance_map[p[0]][p[-1]]
      else
        distance_map[el][p[idx -1]]
      end
    end.sort)[0...-1].inject(&:+)
  end.min
end

def bad_santa(filename)
  distance_map = Hash.new {|h, k| h[k] = Hash.new }
  locations = Set.new
  File.open(filename, 'r') do |file|
    file.each do |line|
      loc_string, distance = line.strip.split(" = ")
      distance = distance.to_i
      loc1, loc2 = loc_string.split("to").map {|str| str.strip.to_sym }
      distance_map[loc1][loc2] = distance
      distance_map[loc2][loc1] = distance
      locations += [loc1, loc2]
    end
  end
  locations.to_a.permutation.map do |p|
    (p.each_with_index.map do |el, idx|
      if idx == 0
        distance_map[p[0]][p[-1]]
      else
        distance_map[el][p[idx -1]]
      end
    end.sort)[1..-1].inject(&:+)
  end.max
end

puts traveling_santa("input9.txt")
puts bad_santa("input9.txt")
