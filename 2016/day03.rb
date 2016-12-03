require 'byebug'

def function(filename)
  File.open(filename, 'r') do |file|
    file.map do |line|
        line.split.map(&:to_i)
    end.to_a.select {|trip| valid_triangle?(trip) }.count
  end
end

puts function("input03.txt")
 
