def look_and_say_once(start_string)
  next_array = []
  accum = ""
  curr_char = ""
  start_string.each_char do |chr|
    curr_char = chr if curr_char.empty?
    if chr == curr_char
      accum += chr
    else
      next_array.push(accum)
      accum = curr_char = chr
    end
  end
  next_array.push(accum)
  next_string = next_array.map { |run| "#{run.length}#{run[0]}" }.join
  next_string
end

def look_and_say(start_string, iterations=1)
  iterations.times do
    start_string = look_and_say_once(start_string)
  end
  start_string
end
str = "1321131112"

x = look_and_say(str, 40)
puts x.length
puts look_and_say(x, 10).length
