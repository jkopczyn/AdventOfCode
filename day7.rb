require 'byebug'

OP_TOKENS = [:AND, :OR, :LSHIFT, :RSHIFT, :NOT]

def wiring(filename)
  wire_map = Hash.new
  File.open(filename, 'r') do |file|
    file.each do |line|
      expression, wire = line.split(" -> ")
      wire_map[wire.to_sym] = expression.split.map do |str| 
        /^[0-9]*$/.match(str) ? str.to_i : str.to_sym
      end
    end
    stack = [:a]
    until stack.empty?
      wire = stack.pop
      next if wire_map[wire].is_a?(Integer)
      dependencies = wire_map[wire].reject do |token| 
        token.is_a?(Integer) or OP_TOKENS.include?(token)
      end
      if dependencies.all { |other_wire| wire_map[other_wire].is_a?(Integer)}
        #compute this value
      else
        stack.push(wire)
        dependencies.each { |w| stack.push(wire) }
        #this might end with a wire on the stack multiple times
      end
    end
  end
  debugger
  wire_map[:a]
end

#put each expression in a bucket
#later expressions trump earlier ones
#
#treat as a stack? push on :a, if it requires others push it back in
#and push the requirements in on top of it
#


def evaluate_expression(expression, wire_map)
  tokens = expression.split.map { |str| /^[0-9]*$/.match(str) ? str.to_i : str.to_sym }
  if tokens.length == 1
    return eval_token(tokens[0],wire_map)
  elsif tokens.length == 2 and tokens[0] == :NOT
    return ~eval_token(tokens[1],wire_map)
  elsif tokens.length > 3
    raise "Invalid Instruction"
  elsif tokens[1] == :OR
    return eval_token(tokens[0],wire_map) | eval_token(tokens[2],wire_map)
  elsif tokens[1] == :AND
    return eval_token(tokens[0],wire_map) & eval_token(tokens[2],wire_map)
  elsif tokens[1] == :LSHIFT
    return eval_token(tokens[0],wire_map) << eval_token(tokens[2],wire_map)
  elsif tokens[1] == :RSHIFT
    return eval_token(tokens[0],wire_map) >> eval_token(tokens[2],wire_map)
  else
    raise "Invalid Instruction"
  end
rescue Exception => e
  debugger
  raise e
end

def eval_token(token, wire_map)
  (token.is_a?(Integer) ? token : wire_map[token]) % 65536
end

puts wiring("input7.txt")
 
