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
        results << "#{medicine[0...idx]}#{v.strip}#{medicine[(idx+k.length)..-1]}".strip
      end
      idx = medicine.index(k,idx+1)
    end
  end
  results.count
end

puts replace_medicine("input19.txt")
 
