require 'set'
require 'byebug'

def optimal_seating(filename)
  feeling_map = Hash.new {|h, k| h[k] = Hash.new {|i, l| i[l] = 0}}
  people = Set.new
  File.open(filename, 'r') do |file|
    file.each do |line|
      begin
        neighbor1, sign, feeling, neighbor2 = /(\w*) would (gain|lose) ([0-9]*) happiness units by sitting next to (\w*)./.match(line)[1..-1]
      rescue => e
        debugger
        raise e
      end
      feeling = feeling.to_i * (sign == "gain" ? 1 : -1)
      neighbor1, neighbor2 = neighbor1.to_sym, neighbor2.to_sym
      feeling_map[neighbor1][neighbor2] += feeling
      feeling_map[neighbor2][neighbor1] += feeling
      people += [neighbor1, neighbor2]
    end
  end
  people.to_a.permutation.map do |p|
    p.each_with_index.map do |el, idx|
      if idx == 0
        feeling_map[p[0]][p[-1]]
      else
        feeling_map[el][p[idx -1]]
      end
    end.inject(&:+)
  end.max
end

def optimal_self_seating(filename)
  feeling_map = Hash.new {|h, k| h[k] = Hash.new {|i, l| i[l] = 0}}
  people = Set.new [:Me]
  File.open(filename, 'r') do |file|
    file.each do |line|
      begin
        neighbor1, sign, feeling, neighbor2 = /(\w*) would (gain|lose) ([0-9]*) happiness units by sitting next to (\w*)./.match(line)[1..-1]
      rescue => e
        debugger
        raise e
      end
      feeling = feeling.to_i * (sign == "gain" ? 1 : -1)
      neighbor1, neighbor2 = neighbor1.to_sym, neighbor2.to_sym
      feeling_map[neighbor1][neighbor2] += feeling
      feeling_map[neighbor2][neighbor1] += feeling
      people += [neighbor1, neighbor2]
    end
  end
  people.to_a.permutation.map do |p|
    p.each_with_index.map do |el, idx|
      if idx == 0
        feeling_map[p[0]][p[-1]]
      else
        feeling_map[el][p[idx -1]]
      end
    end.inject(&:+)
  end.max
end


puts optimal_seating("input13.txt")
puts optimal_self_seating("input13.txt")
