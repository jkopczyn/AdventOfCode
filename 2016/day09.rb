require 'byebug'

def function(filename)
    File.open(filename, 'r') do |file|
        scan_step(file.read.strip)
    end
end

def scan_step(string, decompressed="", decompressed_length=0)
    if not string or string.empty?
        puts decompressed
        return decompressed_length
    end
    left = string.index('(')
    unless left
        decompressed += string
        puts decompressed
        return decompressed_length + string.length
    end
    right = string.index(')', left)
    decompressed += string[0...left]
    decompressed_length += left
    scan_length, repeats = string[left+1...right].split('x').map(&:to_i)
    string = string[right+1..-1]
    decompressed += (string[0...scan_length])*repeats
    decompressed_length += scan_length*repeats
    scan_step(string[scan_length..-1], decompressed, decompressed_length)
end

puts function("input.txt")
