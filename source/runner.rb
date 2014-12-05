require_relative 'battleship.rb'



def run!
  puts GameView.welcome
  battle = Battleship.new
  battle.start
  puts battle

  until battle.finished?
    print GameView.prompt
    input = gets.chomp
    battle.shoot_enemy(input)
    puts battle
  end
end


run!