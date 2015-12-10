require 'byebug'

OP_TOKENS = [:AND, :OR, :LSHIFT, :RSHIFT, :NOT]

class WiringProblem
  attr_accessor :wire_map, :stack
  def initialize(filename, target=:a)
    @wire_map = Hash.new
    @stack = [target]
    File.open(filename, 'r') do |file|
      file.each do |line|
        expression, wire = line.chomp.split(" -> ")
        wire_map[wire.to_sym] = expression.split.map do |str| 
          /^[0-9]*$/.match(str) ? str.to_i : str.to_sym
        end
      end
    end
  end

  def wiring
    until stack.empty?
      wire = stack.pop
      next if wire_map[wire].is_a?(Integer)
      dependencies = wire_map[wire].reject do |token| 
        token.is_a?(Integer) or OP_TOKENS.include?(token)
      end
      if dependencies.all? { |other_wire| wire_map[other_wire].is_a?(Integer)}
        wire_map[wire] = evaluate_expression(wire_map[wire])
      else
        stack.push(wire)
        dependencies.each { |w| stack.push(w) }
        puts "Stack size: #{stack.length}"
        #this might end with a wire on the stack multiple times
        #but line 9 'next if ...' deals with that
      end
    end
    wire_map[:a]
  rescue Exception => e
    debugger
    raise e
  end

  def evaluate_expression(tokens)
    if tokens.length == 1
      return eval_token(tokens[0])
    elsif tokens.length == 2 and tokens[0] == :NOT
      return ~eval_token(tokens[1])
    elsif tokens.length > 3
      raise "Invalid Instruction"
    elsif tokens[1] == :OR
      return eval_token(tokens[0]) | eval_token(tokens[2])
    elsif tokens[1] == :AND
      return eval_token(tokens[0]) & eval_token(tokens[2])
    elsif tokens[1] == :LSHIFT
      return eval_token(tokens[0]) << eval_token(tokens[2])
    elsif tokens[1] == :RSHIFT
      return eval_token(tokens[0]) >> eval_token(tokens[2])
    else
      raise "Invalid Instruction"
    end
  end

  def eval_token(token)
    (token.is_a?(Integer) ? token : wire_map[token]) % 65536
  end
end

problem = WiringProblem.new("input7.txt", :a)
puts problem.wiring()

