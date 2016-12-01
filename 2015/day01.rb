
def first_basement(filename)
  File.open(filename, 'r') do |file|
    a = file.each_char.map do |char|
      if char == '('
        1
      elsif char == ')'
        -1
      else
        0
      end
    end
    floor = 0
    a.each_with_index do |int, idx|
      floor += int
      if floor < 0
        return idx+1
      end
    end
    return -1
  end
end

puts first_basement("input1.txt")
