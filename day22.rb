require 'byebug'

BOSS = {hits: 58, damage: 9}
class Fight_State
  attr_reader :mana
attr_accessor :mana_spent, :player_hits, :boss_hits, :boss_damage, :poison_turns, :shield_turns, :recharge_turns

  def initialize(options={})
    @mana= options[:mana] || 500
    @mana_spent= options[:mana_spent] || 0
    @player_hits= options[:player_hits] || 50
    @boss_hits= options[:boss_hits] || BOSS[:hits]
    @boss_damage= options[:boss_damage] || BOSS[:damage]
    @poison_turns= options[:poison_turns] || 0
    @shield_turns= options[:shield_turns] || 0
    @recharge_turns= options[:recharge_turns] || 0
  end

  def mana=(n)
    if n < @mana
      @mana_spent += (@mana - n)
    end
    @mana = n
  end

  def export()
    options = {}
    options[:mana] = mana
    options[:mana_spent] = mana_spent  
    options[:player_hits] = player_hits
    options[:boss_hits] = boss_hits
    options[:boss_damage] = boss_damage
    options[:poison_turns] = poison_turns
    options[:shield_turns] = shield_turns
    options[:recharge_turns] = recharge_turns
    #debugger
    options
  end

  def evolve(action)
    if self.recharge_turns > 0
      self.mana += 101
      self.recharge_turns -= 1
    end
    if self.poison_turns > 0
      self.boss_hits -= 3
      self.poison_turns -= 1
    end
    if self.shield_turns > 0
      self.shield_turns -= 2
    end
    case action
    when :recharge
      return :loss if self.recharge_turns > 0
      self.mana -= 229
      self.recharge_turns = 5
    when :poison
      return :loss if self.poison_turns > 0
      self.mana -= 173
      self.poison_turns = 6
    when :shield
      return :loss if self.shield_turns > 0
      self.mana -= 113
      self.shield_turns = 6
    when :magic_missile
      self.mana -= 53
      self.boss_hits -= 4
    when :drain
      self.mana -= 73
      self.boss_hits -= 2
      self.player_hits += 2
    else
      return :loss
    end
    return :loss if self.mana < 0
    if self.poison_turns > 0
      self.boss_hits -= 3
      self.poison_turns -= 1
    end
    if self.recharge_turns > 0
      self.mana += 101
      self.recharge_turns -= 1
    end
    return :win if self.boss_hits <= 0
    if self.shield_turns > 0
      self.player_hits -= [self.boss_damage - 7, 1].max
    else
      self.player_hits -= self.boss_damage
    end
    return :loss if self.player_hits <= 0
    return :ongoing
  end
end

def wizard_fighting()
  timelines = [Fight_State.new]
  finished_fights = []
  lowest_cost = 999999
  count = 0
  memos = {}
  until timelines.empty? or timelines.map {|f| f.mana_spent }.min >= lowest_cost
    count += 1
    cand = timelines.shift.export
    p "#{lowest_cost} #{cand}" if count%100 == 0
    next if memos[cand]
    memos[cand] = {}
    [:recharge, :poison, :shield, :magic_missile, :drain].each do |spell|
      timeline = Fight_State.new(cand)
      outcome = timeline.evolve(spell)
      case outcome
      when :loss
        memos[cand][spell] = :loss
        next
      when :win
        memos[cand][spell] = :win
        finished_fights.push(timeline)
      else
        memos[cand][spell] = :ongoing
        timelines.push(timeline) unless timeline.mana_spent >= [lowest_cost, 1362].min
      end
    end
    lowest_cost = finished_fights.map {|f| f.mana_spent }.min || lowest_cost
  end
  lowest_cost
end

puts wizard_fighting()
 
