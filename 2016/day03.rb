require 'byebug'

def function(filename)
  File.open(filename, 'r') do |file|
      storage = []
      triples = []
      file.each do |line|
          storage.push(line.split.map(&:to_i))
          if storage.length == 3
              triples.extend(mixup(storage))
              storage = []
          end
      end
      triples.select {|trip| valid_triangle?(trip) }.count
  end
end

def valid_triangle?(triple)
    a,b,c = triple
    (a+b > c) and (b+c > a) and (a+c > b)
end

puts function("input03.txt")
 
