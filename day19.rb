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
  working = medicine.dup
  key_lengths = {}
  conversions.keys.each { |k| key_lengths[k] = k.gsub(/[a-z]/,'').length }
  keys = conversions.keys.sort!{|k| key_lengths[k] }

  count = 0
  while working.length > 1 do
    dummy = working.dup
    keys.each do |key|
      while working.sub!(key, conversions[key])
        count += 1 
        puts "#{working}, #{key}, #{conversions[key]}"
      end
    end
    puts "check for stale"
    puts dummy, working
    if dummy == working
      keys.shuffle!
      working = medicine.dup
      count = 0
    end
  end
  count
end


puts replace_medicine("input19.txt")
puts shorten_medicine("input19.txt", 'e')
