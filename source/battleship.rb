require_relative 'errors_and_constants.rb'

class Board
  BOARD_LENGTH = 10
  TOP_LABEL = ('A'..'Z').to_a.first(BOARD_LENGTH).unshift("  ")

  def initialize  
    @board = board
  end

  def board
    @board ||= set_board
  end

  def render
    rendered_board = []
    first_row = TOP_LABEL
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
  include ShipConstants
                 
  attr_reader :ship
  attr_accessor :placed

  def initialize(ship_hopeful)
    @ship = set_ship(ship_hopeful)
  end

  def length
    ship[:length]
  end

  def name
    ship[:name]
  end

  def abbr
    ship[:abbr]
  end

  def placed
    ship[:placed]
  end

  private

  def set_ship(ship_hopeful)
    @ship ||= ShipConstants.ship_hash[ship_hopeful]
  end

end

class Game
  include ShipConstants
  include CoordConstants

  DIRECTIONS = ["horizontal", "vertical"]

  def initialize
    @board = set_board
    @ships = ships
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

  def place_ship(ship_type, coord, direction)
    raise InvalidDirectionError, InvalidDirectionError.unknown_direction unless DIRECTIONS.include? direction

    ship = find_ship(ship_type)
    raise ShipError, ShipError.already_placed if ship.placed == true
    
    starting_position = get_coord(coord)
    horz_coord = starting_position[0]
    vert_coord = starting_position[1]

    
    if direction == "horizontal" && valid_start?(horz_coord, ship)
      ending = horz_coord + (ship.length - 1)

      until horz_coord > ending
        board[vert_coord][horz_coord] = ship.abbr
        horz_coord += 1
      end

    elsif direction == "vertical" && valid_start?(vert_coord, ship)
      ending = vert_coord + (ship.length - 1)

      until vert_coord > ending
        board[vert_coord][horz_coord] = ship.abbr
        vert_coord += 1
      end
    end

    ship.placed = true

  end

  private

  def find_ship(ship_type)
    raise ShipError, ShipError.unknown_ship unless ShipConstants.acceptable_ships.include? ship_type
    found = ships.select { |ship| ship.name == ship_type }[0]
    found
  end

  def valid_start?(coord, ship)
    (coord + ship.length) < 9
  end

  def set_board
    @board ||= Board.new
  end

  def ships_init
    @ships = []
    ShipConstants.acceptable_ships.each do |ship|
      @ships << Ship.new(ship)
    end
    @ships
  end

  def get_coord(coord)
    raise InvalidCoordinateError, InvalidCoordinateError.standard unless coord.match(/\A[a-jA-J]\d{1,2}\z/)

    coord_arr = []

    if coord.length == CoordConstants.acceptable_coord_lengths[-1]
      coord_arr << convert_from_letter(coord[0])
      coord_arr << convert_to_index(coord[1..2])

    elsif coord.length == CoordConstants.acceptable_coord_lengths[0]
      coord_arr << convert_from_letter(coord[0])
      coord_arr << convert_to_index(coord[1])
    end

    coord_arr
  end

  def convert_from_letter(coord)
    if CoordConstants.letter_coords.keys.include? coord
      CoordConstants.letter_coords[coord]
    else
      raise InvalidCoordinateError, InvalidCoordinateError.not_on_board
    end
  end 

  def convert_to_index(coord)
    coord = coord.to_i
    if coord <= board.length && coord > 0
      coord - 1
    else
      raise InvalidCoordinateError, InvalidCoordinateError.not_on_board
    end
  end
end


