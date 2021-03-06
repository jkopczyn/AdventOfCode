require 'byebug'
require 'prime'

def factors_of(number)
  return [1] if number == 1
  primes, powers = number.prime_division.transpose
  exponents = powers.map{|i| (0..i).to_a}
  divisors = exponents.shift.product(*exponents).map do |powers|
    primes.zip(powers).map{|prime, power| prime ** power}.inject(:*)
  end
  divisors
end

def sum_factors(target)
  max = target/10
  1.upto(max) do |n|
    tot = factors_of(n).inject(&:+)
    puts "#{n}, #{tot}" if n%144 == 0
    return n if tot >= max
  end
end

def lazy_divisors(number)
  return [1] if number == 1
  primes, powers = number.prime_division.transpose
  exponents = powers.map{|i| (0..i).to_a}
  divisors = exponents.shift.product(*exponents).map do |powers|
    primes.zip(powers).map{|prime, power| prime ** power}.inject(:*)
  end.select {|x| x*50 >= number }
  divisors
end

def lazy_elves(target)
  max = target/11
  1.upto(max) do |n|
    set = lazy_divisors(n)
    tot = set.inject(&:+) unless set.nil?
    puts "#{n}, #{tot}" if n%144 == 0
    return n if tot >= max
  end

end

#puts sum_factors(33100000)
puts lazy_elves(33100000)
