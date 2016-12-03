require 'byebug'

def function(filename)
  File.open(filename, 'r') do |file|
    file.map do |line|
        line.split.map(&:to_i)
    end.to_a.select {|trip| valid_triangle?(trip) }.count
  end
end

def valid_triangle?(triple)
    a,b,c = triple
    (a+b > c) and (b+c > a) and (a+c > b)
end

puts function("input03.txt")
 
