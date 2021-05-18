class Team
  attr_accessor :id, :monpokes, :current_monpoke, :graveyard

  def initialize(id, monpokes = [])
    @id = id
    @monpokes = monpokes
    @current_monpoke = nil
    @graveyard = 0
  end

  def defeated?
    return @graveyard >= @monpokes.count
  end

  def choose(monpoke_id)
    monpoke = @monpokes.find { |m| m.id == monpoke_id }
    if monpoke.nil?
      exit(1)
    end
    @current_monpoke = monpoke

    return "#{monpoke.id} has entered the battle!"
  end
end
