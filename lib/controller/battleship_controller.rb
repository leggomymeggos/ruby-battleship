class BattleshipController
  def initialize
    @battle = battle
  end

  def battle
    @battle
  end

  def start
    puts GameView.welcome
    puts GameView.game_options
    print GameView.prompt
    input = gets.chomp
    @battle = Battleship.new(level: input)
  end
  
  def run!
    input = ""
    self.start
    place_ships

    battle.start
    puts battle
    
    print GameView.prompt
    input = gets.chomp
    until battle.finished? || input == "exit" || input == "quit"
      react(input)
      puts battle
      print GameView.prompt
      input = gets.chomp
    end

    if battle.winner
      puts battle
      puts GameView.winner(battle.winner)
    end
  end

  def place_ships
    puts GameView.ship_options
    print GameView.prompt
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
        
        puts error_catch{
          battle.home.place_ship(ship.name, ship_start, ship_direction)
        }
      end
    end
  end

  def react(input)
    shot = error_catch{ battle.shoot_enemy(input) }
    if battle.hit?(shot)
      puts GameView.hit
    elsif battle.miss?(shot)
      puts GameView.miss
    else
      puts shot
    end

    sleep 0.5
    battle.update_enemy_mock
    battle.shoot_home
  end

  def error_catch(&block)
    begin
      yield
    rescue => e
      return e.message if e.message
    end
  end
end