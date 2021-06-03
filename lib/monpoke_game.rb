require_relative "../lib/game"
require_relative "../lib/team"
require_relative "../lib/monpoke"

module MonpokeGame
  def play(input)
    first_command = (input.shift).split
    action = first_command.shift
    if action == "CREATE"
      game = Game.new(*first_command)
    else
      abort("Invalid Action: First action must create first team and monpoke")
    end

    input.each do |command|
      unless (game.game_over)
        game.play_log << game.play_turn(command.split)
      end
    end
    puts game.play_log
    return game
  end
end
