require 'byebug'

def function(filename)
    bot_map = Hash.new { |k| { number: k, current: [], low: nil, high: nil } }
    File.open(filename, 'r') do |file|
        file.each do |line|
            result = main_loop(bot_map, parse_line(line))
            return result if result
        end
    end
end

def parse_line(string)
    tokens = string.split
    case tokens[0]
    when "value"
        {destination: tokens[-1].to_i, value: tokens[1].to_i}
    when "bot"
        {rule: true, bot: tokens[1].to_i,
         low: label(tokens[5..6]), high: label(tokens[10..11])}
    end
end

def label(pair)
    case pair[0]
    when "bot"
        pair[1].to_i
    when "output"
        pair.join('').to_sym
    end
end

def main_loop(bots, input)
    if input.has_key?(:destination)
        todo = [move_chip(bots, input[:destination], input[:value])]
        until todo.empty?
            current = todo.pop
            return current[:solution] if current.has_key?(:solution)
            handle_move(bots, current).each do |data|
                todo << data unless data.empty?
            end
        end
    elsif input.has_key?(:rule)
        bot = bots[input[:bot]]
        bot[:low], bot[:high] = input[:low], input[:high]
    end
    nil
end

def check_bot(bots, bot)
    if bot[:current].length == 2
        if bot[:current].sort == [17, 61]
            return { solution: bot[:number] }
        end
        low, high = bot[:current].sort
        bots[bot[:number]][:current] = []
        return {low: [bot[:low], low], high: [bot[:high], high]}
    end
    {}
end

def handle_move(bots, move)
    [move_chip(bots, *move[:low]), move_chip(bots, *move[:high])]
end

def move_chip(bots, destination, value)
    target_bot = bots[destination]
    target_bot[:current] << value
    check_bot(bots, target_bot)
end


puts function("input.txt")
