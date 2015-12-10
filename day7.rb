require 'byebug'
def wiring(filename)
  wire_map = Hash.new
  File.open(filename, 'r') do |file|
    queue = file.each.map do |line|
      expression, wire = line.split(" -> ")
      tokens = expression.split.map { |str| /^[0-9]*$/.match(str) ? str.to_i : str.to_sym }
      [wire, tokens]
    end.sort_by {|pair| pair[1].length}
    until queue.empty?
      wire, tokens = queue.dequeue
      case tokens.length
      when
      when
      when
      end
    end
  end
  debugger
  wire_map[:a]
end

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
 
