require 'byebug'
def secret_grid(row, column)
  idx = (column*(column+1)/2) + ((row-1)*(2*column + row - 2))/2
  idx -= 1
  base = 252533
  curr = 20151125 
  while idx > 0
    if idx % 2 == 0
      idx /= 2
      base = (base * base) % 33554393
    else
      curr = (curr * base % 33554393)
      idx -= 1
      #puts "#{base}**#{idx} * #{curr}"
    end
  end
  curr
end

def print_grid(height, width)
  rows = []
  height.times do |row|
    nxt = []
    width.times do |col|
      nxt << secret_grid(row+1, col+1)
    end
    rows << nxt
  end
  rows.each { |row| p row }
end

#puts "#{row = 1}, #{column = 1}, #{secret_grid(row, column)}"
#puts "#{row = 2}, #{column = 1}, #{secret_grid(row, column)}"
#puts "#{row = 1}, #{column = 2}, #{secret_grid(row, column)}"
#puts "#{row = 3}, #{column = 1}, #{secret_grid(row, column)}"
#puts "#{row = 2}, #{column = 2}, #{secret_grid(row, column)}"
#puts "#{row = 3}, #{column = 4}, #{secret_grid(row, column)}"
#puts "#{row = 4}, #{column = 3}, #{secret_grid(row, column)}"
#puts "#{row = 5}, #{column = 1}, #{secret_grid(row, column)}"
#puts "#{row = 7}, #{column = 4}, #{secret_grid(row, column)}"
#print_grid(10,10)
#puts "#{row = 1}, #{column = 8}, #{secret_grid(row, column)}"
puts secret_grid(2978, 3083)
