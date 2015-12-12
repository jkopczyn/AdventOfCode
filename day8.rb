def count_extra_characters(filename)
  count = 0
  File.open(filename, 'r') do |file|
    file.each do |line|
      temp_counter = 0
      line = line.strip
      begin
        if /"(.*)"/.match(line)[1].length == (line.length - 2)
          temp_counter += 2 
        else
          next
        end
      rescue NoMethodError
        next
      end
      temp_counter += 3*line.scan(/(\\x[0-9a-f]{2})/).length
      temp_counter -= 3*line.scan(/(([^\\]|^)\\\\x[0-9a-f]{2})/).length
      temp_counter += line.scan(/\\\"|\\\\/).length
      count += temp_counter
    end
  end
  count
end

def make_more_characters(filename)
  count = 0
  File.open(filename, 'r') do |file|
    file.each.map do |line|
      line.each_char.map do |char|
      ['"',"\\"].include?(char) ? 1 : 0
      end.inject(2, &:+)
    end.inject(&:+)
  end
end

puts count_extra_characters("input8.txt")
puts make_more_characters("input8.txt")
