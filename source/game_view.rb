require_relative 'game'

class GameView
  def initialize(game, enemy_game)
    @game       = game
    @enemy_game = enemy_game
    @mock_board = mock_board
  end

  def render
    @game.to_s
  end

  def self.welcome
<<-welcome

        ******** Welcome to Battleship! *********
         the game where you don't get in trouble 
              for shooting at your friends
welcome
  end

  def self.prompt
    "::> "
  end

  def self.hit(ship_name)
    "#{ship_name} was hit!"
  end

  def self.sunk(ship_name)
    "#{ship_name} has sunk!"
  end

  def self.miss
    "Whiff..."
  end
end