require 'byebug'

def increment_char_with_wrapping(char)
  throw ArgumentError unless ('a'..'z').include?(char)
  ('a'..'z').drop( (('a'..'z').find_index {|c| c == char } +1) % 26 ).first
end

def increment_string(string)
  chars = string.each_char
  throw ArgumentError unless chars.all? { |chr| ('a'..'z').include?(chr) }
  chars = chars.to_a.reverse
  carry = true
  chars.each_with_index do |chr, idx|
    break unless carry
    chars[idx] = chr = increment_char_with_wrapping(chr)
    carry = (chr == 'a')
  end
  chars.reverse.join
end

def contains_run?(password)
  ords = password.each_char.map(&:ord)
  ords.each_index do |idx|
    next if idx < 2
    return true if (ords[idx]-ords[idx-1] == 1) and 
      (ords[idx-1]-ords[idx-2] == 1)
  end
  false
end

def check_valid?(password)
  /(.)\1.*(.)\2/.match(password) and
    not ['i', 'l', 'o'].any? {|c| password.include?(c) } and
    contains_run?(password)
end

def password_gen(password)
  until check_valid?(password)
    password = increment_string(password)
  end
  password
end

old_password = "cqjxjnds"
#puts increment_string(old_password)
#puts increment_string("bccdzzzzzz")
new_pass = password_gen(old_password)
puts new_pass
puts password_gen(increment_string(new_pass))
