require 'byebug'

def function(filename)
  File.open(filename, 'r') do |file|
      storage = []
      triples = []
      file.each do |line|
          storage.push(line.split.map(&:to_i))
          if storage.length == 3
              triples += mixup(storage)
              storage = []
          end
      end
      triples.select {|trip| valid_triangle?(trip) }.count
  end
end

def mixup(three_by_three)
    r0, r1, r2 = three_by_three
    [[r0[0], r1[0], r2[0]], [r0[1], r1[1], r2[1]], [r0[2], r1[2], r2[2]]]
end

def valid_triangle?(triple)
    a,b,c = triple
    (a+b > c) and (b+c > a) and (a+c > b)
end

puts function("input03.txt")
 
