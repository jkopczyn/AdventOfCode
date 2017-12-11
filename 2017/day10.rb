require 'byebug'

def function(filename, size)
    string = size.times.to_a
    start  = 0
    stride = 0
    File.open(filename, 'r') do |file|
        file.read.split(',').map(&:to_i).each do |len|
            munge(string, start, len)
            start = (start + len + stride) % size
            stride += 1
        end
        p string[0...10]
        string[0]*string[1]
    end
end

def munge(list, s, l)
    list.rotate!(s)
    list[0...l] = list[0...l].reverse
    list.rotate!(-s)
    list
end

p function("input.txt", 5)
p function("input10.txt", 256)
