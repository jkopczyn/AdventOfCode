require 'byebug'

def function(filename)
    File.open(filename, 'r') do |file|
        file.each.map do |line|
            words = line.split.map do |word|
                word.chars.sort.join
            end
            (words.uniq == words) ? 1 : 0 
        end.inject(&:+)
    end
end

puts function("input04.txt")
