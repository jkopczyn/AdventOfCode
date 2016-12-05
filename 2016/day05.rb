require 'byebug'
require 'digest'

def function(id)
    i = 1
    output = ['']*8
    while output.select { |s| s != '' }.length < 8
        hash = Digest::MD5.hexdigest(id+i.to_s)
        if hash[0..4] == "00000" and output[hash[5].to_i] == ''
            output[hash[5].to_i] = hash[6]
            p i, output
        end
        i += 1
    end
    output.join('')
end

puts function("ojvtpuvg")
 
