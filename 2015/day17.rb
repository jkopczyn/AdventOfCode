require 'byebug'

def store_nog(filename, eggnog)
  containers = []
  File.open(filename, 'r') do |file|
    file.each do |line|
      containers.push(line.to_i)
    end
  end
  (1..containers.length).map do |length|
    containers.combination(length).select { |list| list.inject(&:+) == eggnog }
  end.inject(&:+).count
end

def store_nog_optimally(filename, eggnog)
  containers = []
  File.open(filename, 'r') do |file|
    file.each do |line|
      containers.push(line.to_i)
    end
  end
  minimum = (1..containers.length).find do |length|
    containers.combination(length).select { |list| list.inject(&:+) == eggnog }.count > 0
  end
  containers.combination(minimum).select { |list| list.inject(&:+) == eggnog }.count
end


puts store_nog("input17.txt", 150)
puts store_nog_optimally("input17.txt", 150)
