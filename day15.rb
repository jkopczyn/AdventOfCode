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
  #d ca/ d sp = ca_sp - ca_pe
  #d ca/ d bu = ca_bu - ca_pe
  #d ca/ d ch = ca_ch - ca_pe
  #d g/d ca = du*fl*te (+ ca * d g/ d ca (du*fl*te))
  #g(sp,bu,ch) = (ca_sp*sp+ca_bu*bu+ca_ch*ch+ca_pe*(100-sp-bu-ch))*...
  #= (ca_pe*100+(ca_sp-ca_pe)sp+(ca_bu-ca_pe)bu+(ca_ch-ca_pe)ch)*...
  #
  #so: calculate constants, figure derivatives, set all to zero, solve(?),
  #approximate if necessary
  #
  #g(sp,bu,ch) ~= (C+C*sp+C*bu+C*ch)*(C+C*sp+C*bu+C*ch)*(C+C*sp+C*bu+C*ch)*(C+C*sp+C*bu+C*ch)
  # ~= (m*sp + C)*(n*sp + D)*(o*sp + E)*(p*sp + F)
  # = 4mnop + 3(mnoF+mnEp+mDop+Cnop)+2(mnEF+CDop+mDoF+CnEp+mDEp+CnoF)+(CDEp+CDoF+CnEF+mDEF)
  # = 0
  # god this is ugly there must be a library for it
end

puts function("input15.txt")
 
