def eggnog_delivery(filename)
  big_map = {[0,0] => true}
  current_position = [0,0]
  File.open(filename, 'r') do |file|
    file.each_char.map do |char|
      move_position(current_position, char)
      big_map[current_position.dup] = true
    end
  end
  big_map.count
end

def robot_delivery(filename)
  big_map = {[0,0] => true}
  santa_position = [0,0]
  robot_position = [0,0]
  File.open(filename, 'r') do |file|
    file.each_char.each_with_index.map do |char, idx|
      current_position = idx % 2 == 0 ? santa_position : robot_position
      move_position(current_position, char)
      big_map[current_position.dup] = true
    end
  end
  big_map.count
end

def move_position(position, char)
  case char
  when '<'
    position[0] -= 1
  when '>'
    position[0] += 1
  when '^'
    position[1] += 1
  when 'v'
    position[1] -= 1
  end
end

puts eggnog_delivery("input3.txt")
puts robot_delivery("input3.txt")
