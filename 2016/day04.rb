require 'byebug'

def function(filename)
  File.open(filename, 'r') do |file|
    file.each do |line|
        valid_room?(line)
    end
  end
end

def valid_room?(label)
    prefix, checksum = label.split(/[\[\]]/)
    counter = Hash.new(0)
    prefix.split('').select { |c| /[a-z]/.match(c) }.each { |c| counter[c] += 1 }
end

puts function("input.txt")
 
