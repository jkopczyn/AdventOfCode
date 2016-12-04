require 'byebug'

def function(filename)
  File.open(filename, 'r') do |file|
    file.map do |line|
        valid_room?(line) 
    end.inject(&:+)
  end
end

def function2(filename)
  File.open(filename, 'r') do |file|
    file.each do |line|
        if valid_room?(line)
            if shift_name(line)
                return line
            end
        end
    end
  end
end

def shift_name(label)
    prefix, checksum = label.split(/[\[\]]/)
    number = prefix.rpartition('-').last.to_i
    prefix.split('-')[0...-1].join(' ').split('').map do |c|
        if c == ' '
           ''
        else
            shift_letter(c, number % 26)
        end
    end.join('') == 'northpoleobjectstorage'
end

def shift_letter(letter, number)
    c = letter.ord
    ((c + number) < 123 ? (c + number) : (c + number) - 26).chr
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

puts function2("input04.txt")
