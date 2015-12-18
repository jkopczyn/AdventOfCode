require 'byebug'

def find_sue(filename, clue_list)
  File.open(filename, 'r') do |file|
    file.each do |line|
    end
  end
end

sender = "children: 3
cats: 7
samoyeds: 2
pomeranians: 3
akitas: 0
vizslas: 0
goldfish: 5
trees: 3
cars: 2
perfumes: 1"

puts find_sue("input16.txt", sender)
 
