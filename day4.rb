require 'digest/md5'

secret = "iwrupvqb"

def integer_enumerator
  Enumerator.new do |yielder|
    n = 0
    loop do
      yielder.yield n
      n = n + 1
    end
  end
end

def adventcoin(prefix, zeroes=5)
  integer_enumerator.each do |int|
    if Digest::MD5.hexdigest(prefix+int.to_s)[0...zeroes] == "0"*zeroes
      return int
    end
  end
end

puts adventcoin(secret)
puts adventcoin(secret, 6)
