require 'byebug'

def twisting_grid(filename)
  File.open(filename, 'r') do |file|
      commands = file.split(", ")
  end
end

puts twisting_grid("input.txt")
