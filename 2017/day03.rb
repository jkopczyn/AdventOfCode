require 'byebug'

def function(number)
    circle = 0
    number.times do |n|
        next if n.even?
        if n*n > number
            circle = (n-2)
            break
        end
    end
    corner = circle*circle
    corner_distance = circle-1
    wrap_num = number - corner
    return corner_distance if wrap_num == 0
    wrap_num = wrap_num % (circle+1)
    if wrap_num*2 <= (circle+1)
        return (corner_distance+2) - wrap_num
    else
        return corner_distance+1 + wrap_num - circle
    end
end

puts function(25)
puts function(26)
puts function(28)
puts function(30)
puts function(36)
puts function(48)
puts function(347991)
#part 2: looked up in OEIS https://oeis.org/A141481
