def wrapping_paper(filename)
  File.open(filename, 'r') do |file|
    file.map do |line|
      l, w, h = line.split('x').map(&:to_i)
      sides = [l*w, w*h, h*l].sort
      3*sides[0]+2*sides[1]+2*sides[2]
    end.inject(&:+)
  end
end

def ribbon(filename)
  File.open(filename, 'r') do |file|
    file.map do |line|
      l, w, h = line.split('x').map(&:to_i)
      volume = l*w*h
      sides = [l+w, w+h, h+l].sort
      2*sides[0]+volume
    end.inject(&:+)
  end
end

puts wrapping_paper("input2.txt")
puts ribbon("input2.txt")
