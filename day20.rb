require 'byebug'

def function(target)
  numbers = {0 => nil}
  max = target/10
  1.upto(max) do |n|
    numbers[n] = recursive(n, numbers)
    puts "#{n}: #{numbers[n]}" if n%1000 == 0
    if numbers[n] >= max
      return n
    end
  end
end

def recursive(n, memo)
  idx = 1
  total = 0
  while true
    step_back = n - (3*idx*idx - idx)/2
    if step_back == 0
      return memo[n] = total + (1 == idx%2 ? n : -1*n)
    elsif step_back < 0
      return memo[n] = total
    end
    if idx % 2 == 1
      total += (memo[step_back] or memo[step_back]= recursive(step_back, memo))
    else
      total -= (memo[step_back] or memo[step_back]= recursive(step_back, memo))
    end
    if idx < 0
      idx = -1*idx + 1
    else
      idx = -1*idx
    end
  end
end

puts function(310)
puts function(33100000)
 
