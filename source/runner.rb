require_relative 'battleship.rb'



class BattleshipController
  def initialize
    @battle = battle
  end

  def battle
    @battle ||= Battleship.new
  end

  def start
    puts GameView.welcome
  end

  def place_ships
    puts GameView.ship_options
    ships = gets.chomp

    if ships == "M"
      battle.home.ships.each do |ship|
        puts battle.home
        puts GameView.place_ship(ship.name)
        print GameView.prompt
        ship_start = gets.chomp
        puts GameView.direction
        print GameView.prompt
        ship_direction = gets.chomp
        battle.home.place_ship(ship.name, ship_start, ship_direction)
      end
    end
  end
  
  def run!
    self.start
    place_ships

    battle.start
    puts battle

    until battle.finished?
      print GameView.prompt
      input = gets.chomp
      if battle.hit?(battle.shoot_enemy(input))
        puts GameView.hit
      else
        puts GameView.miss
      end
      
      battle.update_enemy_mock
      battle.shoot_home
      puts battle
    end
  end
end

battleship = BattleshipController.new
battleship.run!