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
        move_chip(bots, bot[:low], low)
        move_chip(bots, bot[:high], high)
        bot[:current] = []
    end
end


puts function("input.txt")
