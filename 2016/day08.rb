require 'byebug'

def function(filename)
  File.open(filename, 'r') do |file|
    screen = Array.new(3) { Array.new(7) { false }}
    file.each do |line|
        screen = do_op(screen, parse(line))
    end
    screen.map {|row| row.map {|v| v ? 1 : 0 }.inject(&:+) }.inject(&:+)
  end
end

def parse(command)
    [:rect, 0, 0]
end

def do_op(screen, command)
    screen
end

puts function("input.txt")
 
