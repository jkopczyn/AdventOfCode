require 'byebug'

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
  #g(ca,du,fl,te) = (ca*du*fl*te)
  #d g/d ca = du*fl*te (+ ca * d g/ d ca (du*fl*te))
  #ingredients are sprinkles, butterscotch, chocholate, peppermint (not actually)
  #ca = ca_sp * sp + ca_bu * bu + ca_ch * ch + ca_pe * (100-sp-bu-ch)
  #dammit multivariable calc is boring
end

puts function("input15.txt")
 
