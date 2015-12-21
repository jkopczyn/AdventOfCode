require 'byebug'
require 'set'

def replace_medicine(filename)
  conversions = Hash.new {|h, k| h[k] = [] }
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
    idx = 0
    while idx < medicine.length
      match_idx = medicine.find(k,idx)
      conversions[k].each do |v|
        results << "#{medicine[0...match_idx]}#{v}#{medicine[match_idx+1..-1]}"
      end
      idx = match_idx + 1
    end
  end
  results.count
end

puts replace_medicines("input19.txt")
 
