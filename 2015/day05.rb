vowels = "aeiou".chars

def nice_list(filename)
  File.open(filename, 'r') do |file|
    file.each.map do |line|
      word = line.chomp
      enough_vowels = word.tr('^aeiou','').length >= 3
      doubled = !!(/(.)\1/.match word)
      not_naughty = !(/ab|cd|pq|xy/.match word)
      (enough_vowels and doubled and not_naughty) ? 1 : 0
    end.inject(&:+)
  end
end

def new_nice_list(filename)
  File.open(filename, 'r') do |file|
    file.each.map do |line|
      word = line.chomp
      doubled = !!(/(..).*\1/.match word)
      spaced_close = !!(/(.).\1/.match word)
      (doubled and spaced_close) ? 1 : 0
    end.inject(&:+)
  end
end

puts nice_list("input5.txt")
puts new_nice_list("input5.txt")
