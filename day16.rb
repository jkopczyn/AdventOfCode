require 'byebug'

def find_sue(filename, clue_list)
  target_aunt = Aunt.parse(clue_list)
  aunts = []
  File.open(filename, 'r') do |file|
    file.each do |line|
      aunts.push(Aunt.parse(line))
    end
  end
  aunts = aunts.select { |aunt| target_aunt.fuzzy_compare(aunt) }
  p aunts
  puts aunts.map {|a| a.number }
end

class Aunt
  attr_reader :children, :cats, :samoyeds, :pomeranians, :akitas
  attr_reader :vizslas, :goldfish, :trees, :cars, :perfumes, :number

  def initialize(options)
    @number = options[:number] or nil
    @children = options[:children] or nil
    @cats = options[:cats] or nil
    @samoyeds = options[:samoyeds] or nil
    @pomeranians = options[:pomeranians] or nil
    @akitas = options[:akitas] or nil
    @vizslas = options[:vizslas] or nil
    @goldfish = options[:goldfish] or nil
    @trees = options[:trees] or nil
    @cars = options[:cars] or nil
    @perfumes = options[:perfumes] or nil
  end

  def self.parse(string_chunk)
    options = {}
    string_chunk.strip!
    if string_chunk.match(/Sue ([0-9]+): (.*)/)
      number, values = 
        string_chunk.match(/Sue ([0-9]+): (.*)/)[1..2]
      options[:number] = number.to_i
      string_chunk = values.strip
    end
    #debugger
    string_chunk.split(',').each do |pair|
      k, v = pair.split(':')
      options[k.strip.to_sym] = v.to_i
    end
    self.new(options)
  end

  def fuzzy_compare(other)
    [:children, :samoyeds, :akitas,
     :vizslas, :cars, :perfumes].all? do |attribute|
      self.send(attribute).nil? or other.send(attribute).nil? or
        self.send(attribute) == other.send(attribute)
    end and
    [:cats, :trees].all? do |attribute| 
      self.send(attribute).nil? or other.send(attribute).nil? or
        self.send(attribute) < other.send(attribute)
    end and
    [:pomeranians, :goldfish].all? do |attribute|
      self.send(attribute).nil? or other.send(attribute).nil? or
        self.send(attribute) > other.send(attribute)
    end
  end
end


sender = "children: 3, cats: 7, samoyeds: 2, pomeranians: 3, akitas: 0, " +
"vizslas: 0, goldfish: 5, trees: 3, cars: 2, perfumes: 1"

puts find_sue("input16.txt", sender)
 
