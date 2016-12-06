require 'byebug'

def function(filename)
  character_map = []
  File.open(filename, 'r') do |file|
    file.each do |line|
        if character_map.empty?
            character_map = line.split('').map { |c| [c] }
        else
            line.split('').each_with_index { |c, idx| character_map[idx] << c }
        end
    end
  end
  character_map.map { |list| majority(list) }.join('')
end

def majority(characters)
    multiset = Hash.new(0)
    characters.each { |c| multiset[c] += 1 }
    multiset.keys.sort_by { |c| -multiset[c] }.last
end

puts function("input06.txt")
 
