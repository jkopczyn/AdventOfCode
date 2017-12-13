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
        p pipes['0'].uniq!.size
        pipes.keys.each do |k|
            group = pipes[k].uniq
            pipes.delete(k)
            group.each { |v| pipes.delete(v) }
            pipes[k] = group unless group.empty?
        end
        return pipes.size
    end
end

puts function("input.txt")
puts function("input12.txt")
