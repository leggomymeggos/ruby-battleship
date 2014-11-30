class Board
  BOARD_LENGTH = 10
  TOP_LABEL = ('A'..'J').to_a

  def initialize  
    @board = board
  end

  def board
    @board ||= set_board
  end

  def render
    rendered_board = []
    first_row = TOP_LABEL.unshift("  ")
    breaker = "--" * first_row.length
    
    rendered_board << first_row.join("|")
    rendered_board << breaker
    
    board.each.with_index(1) do |row, index|
      num = index.to_s
      if num.length == 1
        num = " " + num  
      end
      rendered_board << (num += "|") + row.join("|")
    end
    rendered_board.join("\n")
  end

  private

  def set_board
    new_board = []
    BOARD_LENGTH.times { new_board << Array.new(BOARD_LENGTH, "o") }
    new_board
  end
end

class Ship
  ACCEPTABLE_SHIPS = [ "Aircraft carrier", "Battleship", "Submarine", "Cruiser", "Destroyer" ]

  SHIP_HASH = { "Aircraft carrier" => { abbr: "a", length: 5, name: "Aircraft carrier" }, 
                "Battleship"       => { abbr: "b", length: 4, name: "Battleship" },
                "Submarine"        => { abbr: "s", length: 3, name: "Submarine" },
                "Cruiser"          => { abbr: "c", length: 3, name: "Cruiser" },
                "Destroyer"        => { abbr: "d", length: 2, name: "Destroyer" }
              }
                     
  attr_reader :ship

  def initialize(ship_hopeful)
    @ship = set_ship(ship_hopeful)
  end

  def length
    @ship[:length]
  end

  def name
    @ship[:name]
  end

  private

  def set_ship(ship_hopeful)
    @ship ||= SHIP_HASH[ship_hopeful]
  end

end

class Game
  SHIPS = [ "Aircraft carrier", "Battleship", "Submarine", "Cruiser", "Destroyer" ]

  def initialize
    @board = set_board
    @ships = ships
  end

  def set_board
    @board ||= Board.new
  end

  def board
    @board.board
  end

  def ships
    @ships ||= ships_init
  end

  def to_s
    @board.render
  end

  def shoot(coord)
    coord = coord.split
  end

  private

  def ships_init
    @ships = []
    SHIPS.each do |ship|
      @ships << Ship.new(ship)
    end
    @ships
  end
end