require 'byebug'

def pack_sleigh(filename)
  presents = []
  File.open(filename, 'r') do |file|
    file.each do |line|
      presents << line.strip.to_i
    end
  end
  p presents
  target_weight = presents.inject(&:+) / 3
  hitting_targets = (5..22).map {|n| presents.combination(n) }.each.select do |comb| 
    puts "#{comb.to_a.length}, #{comb.inject(&:+)}"
    comb.inject(&:+) == target_weight
  end.inject(&:+)
  puts hitting_targets.length
end

puts pack_sleigh("input24.txt")
 
