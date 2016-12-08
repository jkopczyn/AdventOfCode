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
    [:rect, 1, 1]
end

def do_op(screen, command)
    case command[0]
    when :rect
        x, y = command[1..2]
        x.times do |a|
            y.times do |b|
                screen[b][a] = true
            end
        end
    when :column
        x, drop = command[1..2]
        column = screen.map { |line| line[x] }
        column.length.times { |row|
            screen[row][x] = column[(row - drop) % height] }
    when :row
        y, shift = command[1..2]
        row = screen[y].dup
        row.length.times { |idx|
            screen[y][idx] = row[(idx - shift)% row.length] }
    else
        raise "command???"
    end
    screen
end

puts function("input.txt")
 
