require 'byebug'

def function(filename)
    File.open(filename, 'r') do |file|
        weights = {}
        successors = Hash.new { |h,k| h[k] = [] }
        file.each do |line|
            disk, children = line.split('->')
            _, name, weight = disk.strip.match(/(\w*) \((\d*)\)/).to_a
            if children
                children = children.split(',').map(&:strip)
            else
                children = []
            end
            weights[name] = weight.to_i
            successors[name] = children
        end
        [successors, weights]
    end
end

def find_root(tree, foo)
    tree.keys - tree.values.inject(&:+)
end

def rebalance(tree, weights)
    unbalanced_parent, subtree = find_unbalanced(tree, weights)
    children = tree[unbalanced_parent]
    subtree_weights = tree[unbalanced_parent].map {|c| [c, subtree[c]] }.to_h
    sum = subtree_weights.values.inject(&:+)
    length = children.size
    children.each_with_index do |c, i|
        prev_weight = subtree_weights[children[i-1]]
        if (sum - subtree_weights[c]) == (length-1)*prev_weight
            return weights[c] + (prev_weight - subtree_weights[c])
        end
    end
end

def find_unbalanced(tree, weights)
    total_weights = {}
    tree.keys.each do |k|
        if tree[k].empty?
            total_weights[k] = weights[k]
            tree.delete(k)
        end
    end
    while(true)
        tree.keys.each do |k|
            children_weight = tree[k].map { |c| total_weights[c] }
            if children_weight.all?
                if children_weight.inject(&:+) == tree[k].size*children_weight[0]
                    total_weights[k] = tree[k].size*children_weight[0] + weights[k]
                    tree.delete(k)
                else
                    return k, total_weights
                end
            end
        end
    end
end

puts find_root(*function("input.txt"))
puts find_root(*function("input07.txt"))
puts rebalance(*function("input.txt"))
puts rebalance(*function("input07.txt"))
