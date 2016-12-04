require 'byebug'

def function(filename)
  File.open(filename, 'r') do |file|
    file.each do |line|
        puts valid_room?(line)
    end
  end
end

def valid_room?(label)
    prefix, checksum = label.split(/[\[\]]/)
    counter = Hash.new(0)
    prefix.split('').select { |c| /[a-z]/.match(c) }.each { |c| counter[c] += 1 }
    if counter.keys.sort_by { |k| [-counter[k], k] }[0..4].join('') == checksum
        prefix.rpartition('-').last.to_i
    else
        0
    end
end

puts function("input.txt")
 
