require 'byebug'

def function(filename)
    File.open(filename, 'r') do |file|
        decompress(file.read.strip, recursive=true)
    end
end

def decompress(string, recursive=false)
    left = string.index('(')
    return string.length if left.nil?
    right = string.index(')', left)
    scan_length, repeats = string[left+1...right].split('x').map(&:to_i)
    if recursive
        left + repeats * decompress(string[right+1..right+scan_length], true) +
            decompress(string[right+scan_length+1..-1], true)
    else
        left + scan_length*repeats + decompress(string[right+scan_length+1..-1])
    end
end


puts function("input09.txt")
