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
  recipe = {}
  total_ounces = 0
  ingredients.keys.each do |ingredient|
    recipe[ingredient] = 1
    total_ounces += 1
  end
  until total_ounces >= 100
    recipe[best_addition(recipe, ingredients)] += 1
    total_ounces += 1
  end
  [total_score(recipe, ingredients), recipe, ingredients, calories]
end

def best_addition(selection, statistics)
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

def best_substitution(selection, substitutions, statistics)
  substitutions.sort_by do |pair|
    potential = make_substitution(selection.dup, pair)
    total_score(potential, statistics)
  end.last
end

def make_substitution(selection, substitution)
  put_in, put_out = substitution
  return selection if selection[put_out] < 1
  selection[put_in]  += 1
  selection[put_out] -= 1
  selection
end

def soylent_monster(filename)
  total_score, recipe, ingredients, calories = partial_cookie_monster(filename)
  decrease_calories = []
  increase_calories = []
  stable_calories = []
  ingredients.keys.permutation(2).each do |pair|
    put_in, put_out = pair
    if calories[put_in] > calories[put_out]
      increase_calories.push(pair)
    elsif calories[put_in] < calories[put_out]
      decrease_calories.push(pair)
    else
      stable_calories.push(pair)
    end
  end
  cal = total_calories(recipe, calories)
  until cal == 500
    #puts "#{recipe}, #{total_calories(recipe, calories)}, #{total_score(recipe, ingredients)}"
    if cal > 500
      make_substitution(recipe, 
        best_substitution(recipe, decrease_calories, ingredients))
    else
      make_substitution(recipe, 
        best_substitution(recipe, increase_calories, ingredients))
    end
    cal = total_calories(recipe, calories)
  end
  fiddle = best_substitution(recipe, stable_calories, ingredients)
  trial = make_substitution(recipe.dup, fiddle)
  while total_score(trial, ingredients) > total_score(recipe, ingredients)
    recipe = trial
    fiddle = best_substitution(recipe, stable_calories, ingredients)
    trial = make_substitution(recipe.dup, fiddle)
  end
  #puts "#{recipe}, #{total_calories(recipe, calories)}, #{total_score(recipe, ingredients)}"
  total_score(recipe, ingredients)
end

puts cookie_monster("input15.txt")
puts soylent_monster("input15.txt")
