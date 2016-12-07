require 'byebug'

def function(filename)
  File.open(filename, 'r') do |file|
    file.map do |line|
        valid_tls(line) ? 1 : 0
    end.inject(&:+)
  end
end

def valid_tls(string)
   /([a-z])((?!\1)[a-z])\2\1/.match(string) and not /[\w]*\[[\w]*?([a-z])((?!\1)[a-z])\2\1[\w]*?\][\w]*/.match(string) 
end

puts function("input07.txt")
 
