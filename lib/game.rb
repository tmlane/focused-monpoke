class Game
  attr_accessor :team_1, :team_2, :game_over, :current_team, :play_log

  def initialize(team_1_id, monpoke_id, hp, attack)
    @team_1 = Team.new(team_1_id)
    @team_2 = nil
    @game_over = false
    @current_team = @team_1
    @team_1.monpokes << Monpoke.new(monpoke_id, hp, attack)
    @play_log = ["#{monpoke_id} has been assigned to team #{team_1_id}!"]
  end

  def ready_for_battle? #Attack cannot begin unless both teams have a current_monpoke
    if (@team_2)
      return (@team_2.current_monpoke && @team_1.current_monpoke)
    else
      return false
    end
  end

  def create_stage? #Create stage is over after first ICHOOSEYOU
    return !(@team_1.current_monpoke)
  end

  def choose_stage? #Choose stage cannot begin unless team_2 exists
    return (@team_2)
  end

  def play_turn(command)
    action = command.shift
    if action == "CREATE"
      output = create(command)
    elsif action == "ATTACK"
      output = attack()
      pass_turn
    elsif action == "ICHOOSEYOU"
      return exit(1) if !self.choose_stage?
      output = @current_team.choose(command.pop)
      pass_turn
    else
      exit(1)
    end
    return output
  end

  def create(command)
    if !self.create_stage?
      return exit(1)
    end

    team_id = command.shift
    monpoke = Monpoke.new(*command)

    if team_id == @team_1.id
      @team_1.monpokes << monpoke
    elsif @team_2.nil?
      @team_2 = Team.new(team_id)
      @team_2.monpokes << monpoke
    elsif team_id == @team_2.id
      @team_2.monpokes << monpoke
    end
    return "#{monpoke.id} has been assigned to team #{team_id}!"
  end

  def attack
    if !self.ready_for_battle?
      return exit(1)
    end

    attacker = @current_team.current_monpoke
    defender = opposite_team.current_monpoke

    defender.hp -= attacker.ap

    output = "#{attacker.id} attacked #{defender.id} for #{attacker.ap} damage!"

    if !defender.alive?
      output += "\n#{defender.id} has been defeated!"
      opposite_team.graveyard += 1
      opposite_team.current_monpoke = nil

      if opposite_team.defeated?
        output += "\n#{@current_team.id} is the winner!"
        @game_over = true
        return output
      end
    end

    return output
  end

  def opposite_team
    if @current_team == @team_1
      return @team_2
    else
      return @team_1
    end
  end

  def pass_turn
    @current_team = opposite_team
  end
end
