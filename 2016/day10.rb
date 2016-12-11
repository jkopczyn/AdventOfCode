require 'byebug'

def function(filename)
    bot_map = Hash.new { |k| { number: k, current: [], low: nil, high: nil } }
    File.open(filename, 'r') do |file|
        file.each do |line|
            ''
        end
    end
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
