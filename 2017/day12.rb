require 'byebug'

def function(filename)
    File.open(filename, 'r') do |file|
        pipes = Hash.new { |h, k| h[k] = [] }
        file.each do |line|
            key, points = line.split('<->').map(&:strip)
            points = points.split(',').map(&:strip)
            points.push(key)
            points.each { |point| pipes[point] += points }
        end
        pipes.size.times do
            unchanged = true
            pipes.keys.each do |k|
                size = pipes[k].size
                pipes[k].uniq!.sort!
                unchanged |= (size == pipes[k].size)
                pipes[k].each { |v| pipes[v] += pipes[k] }
            end
            break if unchanged
        end
        return pipes['0'].uniq!.size
    end
end

puts function("input.txt")
puts function("input12.txt")
