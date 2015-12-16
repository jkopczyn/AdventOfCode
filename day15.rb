require 'byebug'
require 'matrix'
require 'rational'

COOKIE_VIRTUES = [:capacity, :durability, :flavor, :texture]
COOKIE_PROPERTIES = [:capacity, :durability, :flavor, :texture, :calories]

def cookie_monster(filename)
  partial_cookie_monster(filename)[0]
end

def partial_cookie_monster(filename)
  ingredients = {}
  calories = {}
  File.open(filename, 'r') do |file|
    file.each do |line|
      regex = /(\w+): capacity (-?\d+), durability (-?\d+), flavor (-?\d+), texture (-?\d+), calories (-?\d+)/
      match = regex.match(line.chomp)
      ingredient = match[1].to_sym
      ingredients[ingredient] = Hash[COOKIE_VIRTUES.zip(match[2..5].map(&:to_i))]
      calories[ingredient] = match[6].to_i
    end
  end
  best_for_virtue = {}
  recipe = {}
  total_ounces = 0
  ingredients.keys.each do |ingredient|
    recipe[ingredient] = 1
    total_ounces += 1
  end
  until total_ounces >= 100
    begin
      recipe[best_choice(recipe, ingredients)] += 1
      total_ounces += 1
    rescue Exception => e
      debugger
      throw e
    end
  end
  [total_score(recipe, ingredients), recipe, ingredients, calories]
end

def best_choice(selection, statistics)
  selection.keys.sort_by do |ing|
    potential = selection.dup
    potential[ing] += 1
    total_score(potential, statistics)
  end.last
end

def virtue_score(virtue, selection, statistics)
  score = selection.keys.map do |k|
    selection[k]*statistics[k][virtue]
  end.inject(&:+)
  score > 0 ? score : 0
end

def total_score(selection, statistics)
  COOKIE_VIRTUES.map { |v| virtue_score(v, selection, statistics) }.inject(&:*)
end

def total_calories(selection, calorie_map)
  selection.keys.map {|ing| selection[ing]*calorie_map[ing]}.inject(&:+)
end

def soylent_monster(filename)
  total_score, recipe, ingredients, calories = partial_cookie_monster(filename)

  #puts "#{recipe}, #{calories}, #{total_calories(recipe, calories)}"
end



puts cookie_monster("input15.txt")
puts soylent_monster("input15.txt")
