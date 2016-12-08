require 'byebug'

def function(filename)
  File.open(filename, 'r') do |file|
    screen = Array.new(3) { Array.new(7) { false }}
    file.each do |line|
        screen = do_op(screen, parse(line))
    end
    print_screen(screen)
    screen.map {|row| row.map {|v| v ? 1 : 0 }.inject(&:+) }.inject(&:+)
  end
end

def parse(command)
    tokens = command.split
    case tokens[0]
    when "rect"
        [:rect] + tokens[1].split('x').map(&:to_i)
    when "rotate"
        case tokens[1]
        when "column"
            [:column, tokens[2][-1].to_i, tokens.last.to_i]
        when "row"
            [:row, tokens[2][-1].to_i, tokens.last.to_i]
        end
    end
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
            screen[row][x] = column[(row - drop) % column.length] }
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

def print_screen(screen)
    screen.each do |line|
        puts line.map { |v| v ? '#' : '.' }.join('')
    end
end

puts function("input.txt")
 
