require 'byebug'

#`Hit Points: 100
#Damage: 8
#Armor: 2`

WEAPONS = {8 => 4, 10 => 5, 25 => 6, 40 => 7, 74 => 8}
ARMOR = {0 => 0, 13 => 1, 31 => 2, 53 => 3, 75 => 4, 102 => 5}
RINGS = {25 => [1,0], 50 => [2,0], 100 => [3,0], 
         20 => [0,1], 40 => [0,2], 80 => [0,3]}

#22 ring loadouts, 5 weapons, 6 armor options, 660 possibilities

def shopping_pessimally(boss_hits, boss_damage, boss_armor)
  player = {hits: 100}
  boss = {damage: boss_damage, hits: boss_hits, armor: boss_armor}
  max_cost = 0
  WEAPONS.keys.each do |w|
    ARMOR.keys.each do |a|
      ringsets = (RINGS.keys.combination(2).to_a +
                  RINGS.keys.combination(1).to_a + [[]])
      ringsets.each do |r|
        #debugger
        player[:damage] = WEAPONS[w]+ r.map {|k| RINGS[k][0] }.inject(0, &:+)
        player[:armor] = ARMOR[a]+ r.map {|k| RINGS[k][1] }.inject(0, &:+)
        cost = w+a+r.inject(0, &:+)
        if cost > max_cost and player_margin(player, boss) < 0
          max_cost = cost
        end
      end
    end
  end
  max_cost
end

def shopping_optimally(boss_hits, boss_damage, boss_armor)
  player = {hits: 100}
  boss = {damage: boss_damage, hits: boss_hits, armor: boss_armor}
  min_cost = 99999
  WEAPONS.keys.each do |w|
    ARMOR.keys.each do |a|
      ringsets = (RINGS.keys.combination(2).to_a +
                  RINGS.keys.combination(1).to_a + [[]])
      ringsets.each do |r|
        #debugger
        player[:damage] = WEAPONS[w]+ r.map {|k| RINGS[k][0] }.inject(0, &:+)
        player[:armor] = ARMOR[a]+ r.map {|k| RINGS[k][1] }.inject(0, &:+)
        cost = w+a+r.inject(0, &:+)
        if cost < min_cost and player_margin(player, boss) > 0
          min_cost = cost
        end
      end
    end
  end
  min_cost
end

def player_margin(player_stats, boss_stats)
  inflict = [player_stats[:damage] - boss_stats[:armor], 1].max
  receive = [boss_stats[:damage] - player_stats[:armor], 1].max
  rounds = -1* ((-1 * boss_stats[:hits])/inflict) #negated division rounds 'up'
  player_stats[:hits] - (rounds - 1)*receive
end

puts shopping_optimally(100, 8, 2)
puts shopping_pessimally(100, 8, 2)
 
