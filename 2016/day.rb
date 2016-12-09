require 'byebug'

def function(filename)
    File.open(filename, 'r') do |file|
        #file.read.strip
        file.each do |line|
            ''
        end
    end
end

puts function("input.txt")
