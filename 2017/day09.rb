require 'byebug'

def garbagegroups(filename)
    File.open(filename, 'r') do |file|
        groups  = Hash.new { |h,k| h[k] = [] }
        level = 0
        group_stack = []
        skip_next = false
        in_garbage = false
        garbage_count = 0
        file.read.strip.chars.each do |char|
            group_stack.map! { |string| string + char }
            if skip_next
                skip_next = false
                next
            end
            if in_garbage
                if char == '>'
                    in_garbage = false
                    next
                elsif char != '!'
                    garbage_count += 1
                    next
                end
            end
            case char
            when '}'
                #p group_stack
                groups[level].push(group_stack.pop)
                level -= 1
                skip_next = false
            when ','
                skip_next = false
            when '!'
                skip_next = true
            when '<'
                in_garbage = true
            when '{'
                level += 1
                group_stack.push('{')
            else
                raise "Character #{char} is not valid outside garbage"
            end
        end
        [groups.each.map { |k,v| k*v.length }.inject(&:+), garbage_count]
    end
end

p garbagegroups("input.txt")
p garbagegroups("input09.txt")
