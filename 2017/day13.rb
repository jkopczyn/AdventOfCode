require 'byebug'

def function(filename)
    File.open(filename, 'r') do |file|
        scanners = {}
        max_depth = 0
        file.each do |line|
            depth, width = line.split(':').map(&:strip).map(&:to_i)
            scanners[depth] = width
            max_depth = [max_depth, depth].max
        end
        severity = 0
        (0..max_depth).each do |d|
            next unless scanners[d]
            cycle_time = (scanners[d]-1)*2
            if d % cycle_time == 0
                severity += d*scanners[d]
            end
        end
        severity
    end
end

def function2(filename)
    File.open(filename, 'r') do |file|
        scanners = {}
        max_depth = 0
        total_cycle = 1
        file.each do |line|
            depth, width = line.split(':').map(&:strip).map(&:to_i)
            scanners[depth] = width
            max_depth = [max_depth, depth].max
            total_cycle *= (width-1)*2
        end
        (total_cycle*3).times do |n|
            failure = false
            (0..max_depth).each do |d|
                next unless scanners[d]
                cycle_time = (scanners[d]-1)*2
                if (d+n) % cycle_time == 0
                    failure = true
                    break
                end
            end
            return n unless failure
        end 
        return nil
    end
end


puts function("input.txt")
puts function("input13.txt")
puts function2("input.txt")
puts function2("input13.txt")
