require 'byebug'
require 'matrix'
require 'rational'

COOKIE_VIRTUES = [:capacity, :durability, :flavor, :texture, :calories]

def cookie_monster(filename)
  ingredients = {}
  File.open(filename, 'r') do |file|
    file.each do |line|
      regex = /(\w+): capacity (-?\d+), durability (-?\d+), flavor (-?\d+), texture (-?\d+), calories (-?\d+)/
      match = regex.match(line.chomp)
      ingredient = match[1].to_sym
      ingredients[ingredient] = Hash[COOKIE_VIRTUES.zip(match[2..6].map(&:to_i))]
    end
  end
  size_of_matrix = 8
  #only works if there are exactly 4 ingredients
  fm = future_matrix = Array.new(size_of_matrix) { Array.new(size_of_matrix) }
  fm[4] = [1]*4+[0]*4
  3.times { |idx| future_matrix[5+idx][4+idx..5+idx] = [1,-1] }

  ingredients.keys.sort.each_with_index do |ing, idx|
    COOKIE_VIRTUES.each_with_index do |v, j| 
      fm[j][idx] = ingredients[ing][v] 
    end
  end

  constants = [[0], [0], [0], [0], [100], [0], [0], [0]].each do |row| 
    row.map! { |el| el ? Rational(el) : Rational(0) }
  end
  fm.each { |row| row.map! { |el| el ? Rational(el) : Rational(0) } }
  m = Matrix::LUPDecomposition.new(Matrix[*fm])
  b = Matrix[*constants]
  puts m
  debugger
  puts m.solve(b)
  #g(ca,du,fl,te) = (ca*du*fl*te)
  #d g/d ca = du*fl*te (+ ca * d g/ d ca (du*fl*te))
  #ingredients are sprinkles, butterscotch, chocholate, peppermint (not actually)
  #ca = ca_sp * sp + ca_bu * bu + ca_ch * ch + ca_pe * pe
  #
  #  a  b  c  d  m  n  o  p  =  ?
  #  2  0  0  0 -1  0  0  0     0
  #  0  5  0 -1  0 -1  0  0     0
  # -2 -3  5  0  0  0 -1  0     0
  #  0  0 -1  5  0  0  0 -1     0
  #  ^ define the VIRTUES values
  #  1  1  1  1  0  0  0  0   100
  #  ^ the ingredient constraint
  #  0  0  0  0  1 -1  0  0     0
  #  0  0  0  0  0  1 -1  0     0
  #  0  0  0  0  0  0  1 -1     0
  #  ^ set them all equal
  #
  #
  #m=2a, n=5b-d, o=-2a-3b+5c, p=-c+5d, a+b+c+d=100, m=n=o=p
 
end

puts cookie_monster("input15.txt")
 
