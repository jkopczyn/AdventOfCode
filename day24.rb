require 'byebug'
require 'set'

def pack_sleigh(filename)
  presents = []
  File.open(filename, 'r') do |file|
    file.each do |line|
      presents << line.strip.to_i
    end
  end
  p presents.sort!
  target_weight = presents.inject(&:+) / 3
  shortest_possible = []
  while shortest_possible.inject(0, &:+) < target_weight
    shortest_possible = presents.last(shortest_possible.length + 1)
  end
  shortest_possible = shortest_possible.length
  shortest_possible.upto(presents.length - shortest_possible).each do |n|
    break unless presents.combination(n).each do |set|
      if set.inject(&:+) == target_weight
        shortest_possible = n
        break
      end
    end
  end
  target_sets = presents.combination(shortest_possible).select {|set| 
    set.inject(&:+) == target_weight }
  p target_sets.length
  min_entangle = 99999999999999999999999999999999
  target_sets.each do |set|
    entangle = set.inject(1, &:*)
    next if entangle >= min_entangle
    others = Set.new(presents) - Set.new(set)
    proof = false
    (shortest_possible..others.length).each do |len|
      others.to_a.combination(len).each do |subset|
        if subset.inject(&:+) == target_weight
          proof = true
          break
        end
      end
      break if proof
    end
    min_entangle = entangle if proof
  end
  min_entangle
end

puts pack_sleigh("input24.txt")
 
  #possible_sets = Set.new([Set.new()])
  #target_sets = Set.new()
  #dead_ends = Set.new()
  #presents.each do |present|
  #  more_possibilities = Set.new()
  #  possible_sets.each do |set|
  #    new = set.dup.add(present)
  #    next if dead_ends.include?(new) or target_sets.include?(new) or
  #      possible_sets.include?(new)
  #    if new.inject(&:+) == target_weight
  #      target_sets.add(new)
  #    elsif new.inject(&:+) < target_weight
  #      more_possibilities.add(new)
  #    else
  #      dead_ends.add(new)
  #    end
  #  end
  #  possible_sets.merge(more_possibilities)
  #  puts "#{target_sets.length} #{possible_sets.length} #{dead_ends.length}"
  #end

#  until possible_sets.empty?
#    head = possible_sets.pop
#    presents.each do |present|
#      next if head.include?(present)
#      new = head.dup.add(present)
#      next if dead_ends.include?(new) or target_sets.include?(new) or
#        possible_sets.include?(new)
#      if new.inject(&:+) == target_weight
#        target_sets.add(new)
#      elsif new.inject(&:+) < target_weight
#        possible_sets << new
#      else
#        dead_ends.add(new)
#      end
#    end
#    puts "#{target_sets.length} #{possible_sets.length} #{dead_ends.length}"
#  end

