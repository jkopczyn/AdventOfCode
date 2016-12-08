require 'byebug'

def function(filename)
  File.open(filename, 'r') do |file|
    screen = Array.new(3) { Array.new(7) { false }}
    file.each do |line|
        do_op(screen, parse(line))
    end
    screen.map {|row| row.select {|v| v }}.inject(&:+)
  end
end

def parse(command)
    [:rect, 0, 0]
end

def do_op(screen, command)
    screen
end

puts function("input.txt")
 
