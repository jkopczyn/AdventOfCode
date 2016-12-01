require 'json'
require 'byebug'

def parse_for_numbers(obj)
  if obj.is_a?(Integer)
    obj
  elsif obj.is_a?(Array)
    obj.map {|entry| parse_for_numbers(entry) }.inject(&:+)
  elsif obj.is_a?(Hash)
    obj.values.map {|entry| parse_for_numbers(entry) }.inject(&:+)
  else
    0
  end
end

def parse_for_nonred_numbers(obj)
  if obj.is_a?(Integer)
    obj
  elsif obj.is_a?(Array)
    obj.map {|entry| parse_for_nonred_numbers(entry) }.inject(&:+)
  elsif obj.is_a?(Hash)
    if obj.values.include?("red")
      0
    else
      obj.values.map {|entry| parse_for_nonred_numbers(entry) }.inject(&:+)
    end
  else
    0
  end
end

def find_nonred_numbers(filename)
  File.open(filename, 'r') do |file|
    json_obj = JSON.parse(file.each.to_a.join(" "))
    return parse_for_nonred_numbers(json_obj)
  end
end

def find_numbers(filename)
  File.open(filename, 'r') do |file|
    json_obj = JSON.parse(file.each.to_a.join(" "))
    return parse_for_numbers(json_obj)
  end
end

puts find_numbers("input12.txt")
puts find_nonred_numbers("input12.txt")
