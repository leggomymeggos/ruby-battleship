
class GameView
  def initialize(game, enemy_game)
    @game       = game
    @enemy_game = enemy_game
  end

  def render
    @game.to_s
  end

  def self.welcome
<<-welcome

              ************* Welcome to Battleship! **************
                  the game where you don't get in trouble
                        for shooting at your friends

welcome
  end

  def self.game_options
    "Pick your level: \"easy\" or \"hard\"."
  end

  def self.ship_options
    "Type \"A\" to let the computer place your ships. Type \"M\" to place them yourself."    
  end

  def self.place_ship(ship_name)
    "Pick a starting coordinate to place the #{ship_name}."
  end

  def self.direction
    "Pick a direction (either horizontal or vertical) to place the ship."
  end

  def self.prompt
    "::> "
  end

  def self.hit
    "A direct hit!"
  end

  def self.winner(winner)
    "#{winner} wins!"
  end

  def self.sunk(ship_name)
    "#{ship_name} has sunk!"
  end

  def self.miss
    "Whiff..."
  end
end