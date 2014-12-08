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

              ************* Welcome to Battleship! **************
                  the game where you don't get in trouble 
                        for shooting at your friends

Type "A" to let the computer place your ships. Type "M" to place them yourself.
welcome
  end

  def self.ship_options
  end

  def self.place_ship(ship_name)
    "Pick a starting coordinate to place #{ship_name}."
  end

  def self.direction
    "Pick a direction (either horizontal or vertical) to place the ship."
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