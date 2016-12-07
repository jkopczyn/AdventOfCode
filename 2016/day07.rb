require 'byebug'

def function(filename)
  File.open(filename, 'r') do |file|
    file.map do |line|
        valid_ssl(line) ? 1 : 0
    end.inject(&:+)
  end
end

def valid_tls(string)
   /([a-z])((?!\1)[a-z])\2\1/.match(string) and not /[\w]*\[[\w]*?([a-z])((?!\1)[a-z])\2\1[\w]*?\][\w]*/.match(string) 
end

def valid_ssl(string)
    pieces = string.split(/[\[\]]/)
    outside = pieces.select.each_with_index { |_, i| i.even? }
    inside  = pieces.select.each_with_index { |_, i| i.odd? }
    babs = outside.map do |substring| 
        substring.scan(/(([a-z])((?!\2)[a-z])\2)/) 
    end.flatten(1).map {|arr| arr[2]+arr[1]+arr[2] }
    p inside, babs
    inside.any? {|substring| babs.any? {|bab| not substring.scan(bab).empty? }}
end
puts function("input.txt")
