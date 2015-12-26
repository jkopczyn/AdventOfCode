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

def pack_harder(filename)
  presents = []
  File.open(filename, 'r') do |file|
    file.each do |line|
      presents << line.strip.to_i
    end
  end
  p presents.sort!
  target_weight = presents.inject(&:+) / 4
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
          other_others = Set.new(others) - Set.new(subset)
          (shortest_possible..other_others.length).each do |sublen|
            other_others.to_a.combination(len).each do |subsubset|
              if subsubset.inject(&:+) == target_weight
                proof = true
                break
              end
            end
            break if proof
          end
          break if proof
        end
      end
      break if proof
    end
    min_entangle = entangle if proof
  end
  min_entangle
end


puts pack_sleigh("input24.txt")
puts pack_harder("input24.txt")
