require_relative "lib/monpoke_game"
include MonpokeGame
input = ARGF.readlines
MonpokeGame.play(input)
