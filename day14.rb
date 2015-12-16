require 'byebug'

def reindeer_facts(filename)
  reindeer_stats = {}
  File.open(filename, 'r') do |file|
    file.each do |line|
      name, speed, time, rest = 
        /(\w*) can fly ([0-9]+) km\/s for ([0-9]+) seconds, but then must rest for ([0-9]+) seconds/.match(line)[1..-1]
      reindeer_stats[name.to_sym] = [speed, time, rest].map(&:to_i)
    end
  end
  reindeer_stats
end

def olympics(filename, race_length)
  reindeer_stats = reindeer_facts(filename)
  reindeer= reindeer_stats.keys
  reindeer.map do |deer|
    speed, time, rest = reindeer_stats[deer]
    cycle_length = time + rest
    distance_traveled = (speed*time)* (race_length / cycle_length)
    ([(race_length % cycle_length), time].min * speed) + distance_traveled
  end.max
end

def newlympics(filename, race_length)
  reindeer_stats = reindeer_facts(filename)
  reindeer= reindeer_stats.keys
  reindeer_points = Hash[reindeer.map { |o| [o, 0] }]
  reindeer_position = Hash[reindeer.map { |o| [o, 0] }]
  race_length.times do |i| 
    reindeer.each do |deer|
      speed, time, rest = reindeer_stats[deer]
      reindeer_position[deer] += speed if (i % (time + rest)) < time
    end
    furthest = reindeer_position.values.max
    reindeer.each do |deer|
      reindeer_points[deer] +=1 if reindeer_position[deer] == furthest
    end
  end
  reindeer_points.values.max
end

puts olympics("input14.txt", 2503)
puts newlympics("input14.txt", 2503)
