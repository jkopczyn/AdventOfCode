require 'byebug'
require 'digest'

def keygen(salt, target=64)
    digest = Digest::MD5.new
    i = -1
    keys = []
    storage = {}
    while keys.length < target
        i += 1
        hash = hash_gen(digest, salt, i, storage)
        c = check_triple(hash)
        next unless c
        #puts "#{i}, #{c}"
        1000.times do |j|
            hash = hash_gen(digest, salt, i+1+j, storage)
            next unless check_quintuple(hash, c)
            keys.push(i)
            puts "#{i}, #{j}"
            break
        end
    end
    keys.last
end

def hash_gen(digest, salt, msg, storage)
    storage[salt] = {} unless storage[salt]
    unless storage[salt][msg]
        storage[salt][msg] = digest.hexdigest(salt + msg.to_s)
    end
    storage[salt][msg]
end


def check_triple(hexstring)
    hexstring.chars.each_with_index do |c, i|
        return c if c == hexstring[i+1] and c == hexstring[i+2]
    end
    return false
end

def check_quintuple(hexstring, char)
    (hexstring.length - 4).times do |i|
        if hexstring.chars[i..i+4].all? { |el| el == char }
            return true
        end
    end
    false
end


digest = Digest::MD5.new
puts keygen("abc", 1)
puts keygen("yjdafjpo")
