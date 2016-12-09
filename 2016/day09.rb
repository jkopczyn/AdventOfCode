require 'byebug'

def function(filename)
    File.open(filename, 'r') do |file|
        scan_step(file.read.strip)
    end
end

def scan_step(string)
    left = string.index('(')
    return string.length unless left
    right = string.index(')', left)
    scan_length, repeats = string[left+1...right].split('x').map(&:to_i)
    left + scan_length*repeats + scan_step(string[right+scan_length+1..-1])
end

def decompress(string)
    left = string.index('(')
    return string.length if left.nil?
    right = string.index(')', left)
    scan_length, repeats = string[left+1...right].split('x').map(&:to_i)
    left + repeats * decompress(string[right+1..right+scan_length]) +
        decompress(string[right+scan_length+1..-1])
end


puts function("input09.txt")
