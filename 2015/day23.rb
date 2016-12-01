require 'byebug'

class Turing
  attr_accessor :a, :b, :idx
  def initialize(a)
    @a = a
    @b = @idx = 0
  end
end

def parse(filename, a=0)
  instructions = nil
  File.open(filename, 'r') do |file|
    instructions = file.map do |line|
      line.split(/[\s,]+/)
    end
    instructions.each do |l|
      l[0] = l[0].to_sym
      l[-1] = l[-1].to_i if [:jmp, :jio, :jie].include?(l[0])
    end
  end
  t = Turing.new(a)
  while 0 <= t.idx and t.idx < instructions.length
    i = instructions[t.idx]
    case i[0]
    when :jmp
      t.idx += i[1]
    when :jie
      t.idx += (t.send(i[1]) % 2 == 0 ? i[2] : 1)
    when :jio
      t.idx += (t.send(i[1]) == 1 ? i[2] : 1)
    when :hlf
      t.send("#{i[1]}=", t.send(i[1])/2)
      t.idx += 1
    when :tpl
      t.send("#{i[1]}=", t.send(i[1])*3)
      t.idx += 1
    when :inc
      t.send("#{i[1]}=", t.send(i[1])+1)
      t.idx += 1
    else
      break
    end
    #puts "#{i.inspect}, #{t.inspect}, next instruction #{instructions[t.idx]}" 
  end
  t.b
end

puts parse("input23.txt")
puts parse("input23.txt", 1)
 
