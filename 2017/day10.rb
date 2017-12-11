require 'byebug'

def one_round(filename, size)
    string = size.times.to_a
    start  = 0
    stride = 0
    File.open(filename, 'r') do |file|
        code = file.read.split(',').map(&:to_i)
        string, _, _ = supermunge(start, stride, string, code)
        p string[0...10]
        string[0]*string[1]
    end
end

def supermunge(start, stride, string, code)
    size = string.size
    code.each do |len|
        munge(string, start, len)
        start = (start + len + stride) % size
        stride += 1
    end
    [string, start, stride]
end

def munge(list, s, l)
    list.rotate!(s)
    list[0...l] = list[0...l].reverse
    list.rotate!(-s)
    list
end

def byte(char)
    char.getbyte(0)
end

def main(filename, rounds)
    File.open(filename, 'r') do |file|
        string = file.read
        many_round(string, rounds)
    end
end

def many_round(input, rounds)
    string = 256.times.to_a
    code = input.split('').map { |s| byte(s) }
    code += [17, 31, 73, 47, 23]
    start  = 0
    stride = 0
    rounds.times do
        string, start, stride = supermunge(start, stride, string, code)
    end
    bytes = 16.times.map do |n|
        string[16*n...(16*(n+1))].inject(&:^)
    end
    bytes.map { |n| n.to_s(16) }.inject(&:+)
end


p one_round("input.txt", 5)
p one_round("input10.txt", 256)
debugger
p many_round('', 64)
p main("input10.txt", 64)
