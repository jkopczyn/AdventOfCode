require 'byebug'

def function(filename, history=false)
    File.open(filename, 'r') do |file|
        registers = Hash.new(0)
        max_ever = 0
        file.each do |line|
            reg, op, amt, _, reg2, cond, thresh = line.split
            if check_cond(registers, reg2, cond, thresh)
                registers = do_op(registers, reg, op, amt)
                if history
                    max_ever = [max_ever, registers[reg]].max
                end
            end
        end
        [registers.values.max, max_ever].max
    end
end

def check_cond(regs, target, condition, threshold)
    threshold = threshold.to_i
    case condition
    when ">"
        regs[target] > threshold
    when "<"
        regs[target] < threshold
    when ">="
        regs[target] >= threshold
    when "<="
        regs[target] <= threshold
    when "=="
        regs[target] == threshold
    when "!="
        regs[target] != threshold
    end
end

def do_op(regs, target, op, amount)
    amount = amount.to_i
    if op == "inc"
        regs[target] += amount
    elsif op == "dec"
        regs[target] -= amount
    end
    regs
end

puts function("input.txt")
puts function("input08.txt")
puts function("input.txt", history=true)
puts function("input08.txt", history=true)
