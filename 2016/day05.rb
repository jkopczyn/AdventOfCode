require 'byebug'
require 'digest'

def function(id)
    i = 1
    output = ['']*8
    while output.select { |s| s != '' }.length < 8
        hash = Digest::MD5.hexdigest(id+i.to_s)
        if hash[0..4] == "00000" and is_decimal(hash[5]) and output[is_decimal(hash[5])] == ''
            output[hash[5].to_i] = hash[6]
            p i, output
        end
        i += 1
    end
    output.join('')
end

def is_decimal(char)
    ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'].include?(char) ? char.to_i : false
end


puts function("ojvtpuvg")
 