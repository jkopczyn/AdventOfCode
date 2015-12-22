require 'byebug'
require 'set'

def replace_medicine(filename)
  conversions = Hash.new {|h, k| h[k] = [] }
  medicine = nil
  File.open(filename, 'r') do |file|
    file.each do |line|
      if line.strip!.empty?
        next
      elsif line.match(/=>/)
        input, output = line.split("=>").map(&:strip)
        conversions[input] << output
      else
        medicine = line
      end
    end
  end
  results = Set.new()
  conversions.keys.each do |k|
    idx = medicine.index(k,0)
    while idx and idx < medicine.length
      conversions[k].each do |v|
        results << 
          "#{medicine[0...idx]}#{v.strip}#{medicine[(idx+k.length)..-1]}".strip
      end
      idx = medicine.index(k,idx+1)
    end
  end
  results.count
end

def shorten_medicine(filename, goal)
  conversions = {}
  medicine = nil
  File.open(filename, 'r') do |file|
    file.each do |line|
      if line.strip!.empty?
        #nothing
      elsif line.match(/=>/)
        input, output = line.split("=>").map(&:strip)
        conversions[output] = input
      else
        medicine = line
      end
    end
  end
  #alright let's do some A*
  #heuristic is length difference/max drop

  @heuristic_factor = conversions.map {|k,v| k.length - v.length }.max
  def heuristic(string)
    string.gsub(/[a-z]/,'').length / (1.0*@heuristic_factor)
  end
  interior = Set.new()
  frontier = Set.new([medicine])
  distance_from_start = Hash.new{|h,k| h[k] = 1.0/0.0 }
  distance_from_start[medicine] = 0 
  total_distance_estimate = Hash.new{|h,k| h[k] = 1.0/0.0 }
  total_distance_estimate[medicine] = heuristic(medicine)

  until frontier.empty?
    point = frontier.min_by {|str| heuristic(str) }
    puts "closest is #{heuristic(point)}, size of frontier #{frontier.count} #{point if point.length < 20}"
    if point == goal
      return distance_from_start[point]
    end
    frontier.delete(point)
    interior.add(point)
    for k in conversions.keys
      v = conversions[k]
      idx = point.index(k,0)
      while idx and idx < point.length
        neighbor = "#{point[0...idx]}#{v}#{point[(idx+k.length)..-1]}"
        if interior.include?(neighbor)
          idx = point.index(k,idx+1)
          next
        elsif not frontier.include?(neighbor)
          frontier.add(neighbor)
        elsif (distance_from_start[point]+1) >= distance_from_start[neighbor]
          idx = point.index(k,idx+1)
          next
        else 
          distance_from_start[neighbor] = distance_from_start[point] + 1
          total_distance_estimate[neighbor] = 
            distance_from_start[neighbor] + heuristic(neighbor)
          idx = point.index(k,idx+1)
        end
      end
    end
  end
  return nil
end


puts replace_medicine("input19.txt")
puts shorten_medicine("input19.txt", 'e')
