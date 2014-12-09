require_relative 'game_view'
require_relative 'computer_ai'

class Battleship
  BREAKER = "\n---------------------------\n"
  def initialize(settings=nil)
    @home       = home
    @enemy      = enemy
    @enemy_mock = enemy_mock
    @settings   = settings
  end

  def home
    @home ||= Game.new
  end

  def enemy_mock
    @enemy_mock ||= Board.new
  end

  def to_s
    " Your Board\n" + home.to_s + BREAKER + " Enemy Board\n" + enemy_mock.render
  end

  def start
    enemy.populate_board
    home.populate_board
  end

  def update_enemy_mock
    enemy.board.each_with_index do |row, x|
      y = 0
      row.each do |space|
        if space == Game::HIT || space == Game::MISS
          enemy_mock.board[x][y] = space
        end
        y += 1
      end
    end
  end

  def finished?
    !winner.nil?
  end

  def winner
    if home.finished?
      @winner = "Computer"
    elsif enemy.finished?
      @winner = "Human"
    else
      @winner = nil
    end
    @winner
  end

  def hit?(shot)
    shot.include? Game::HIT
  end

  def miss?(shot)
    shot.include? Game::MISS
  end

  def shoot_enemy(coord)
    enemy.shoot(coord)
  end

  def shoot_home
    if enemy.class == ComputerAI
      home.smart_shot
    else
      home.shoot(home.send(:random_coord))
    end
  end

  private

  def enemy
    @enemy ||= which_enemy
  end

  def which_enemy
    if @settings == "hard"
      ComputerAI.new
    else
      Game.new
    end
  end
end
