require_relative 'board_and_ship.rb'

class Game
  include ShipConstants
  include CoordConstants
  include BoardConstants

  DIRECTIONS = ["horizontal", "vertical"]
  HIT = "/"
  MISS = "o"

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

  def shoot(coord)
    coord = get_coords(coord)
    x = coord.last
    y = coord.first
    if hit?(coord)
      board[x][y] = HIT
    else
      board[x][y] = MISS
    end
  end

  def populate_board
    ships.each do |ship| 
      next if ship.placed
      direction = random_direction

      coords = get_valid_start(ship, direction)
      
      strung_coords = stringify_coords(coords)
      
      place_ship(ship.name, strung_coords, direction)
    end
    return self
  end

  def place_ship(ship_type, coords, direction)
    raise InvalidDirectionError, InvalidDirectionError.unknown_direction unless DIRECTIONS.include? direction

    ship = find_ship(ship_type)
    raise ShipError, ShipError.already_placed if ship.placed == true

    starting_position = get_coords(coords)
    raise ShipError, ShipError.space_taken unless room_for_ship?(starting_position, ship, direction)
    
    horz_coord = starting_position.first
    vert_coord = starting_position.last

    
    if ship_fits_on_board?(starting_position, ship, direction)
      if direction == "horizontal"
        ending = check_ship_length(horz_coord, ship.length)

        until horz_coord > ending
          board[vert_coord][horz_coord] = ship.abbr
          horz_coord += 1
        end

      elsif direction == "vertical"
        ending = check_ship_length(vert_coord, ship.length)
        
        until vert_coord > ending
          board[vert_coord][horz_coord] = ship.abbr
          vert_coord += 1
        end
      end
      ship.placed = true
    end
    
  end

  private

  def hit?(coord)
    !empty_space?(coord) && space_at(coord) != MISS
  end

  def empty_space?(coord) # => [0, 0]
    x = coord[1]
    y = coord[0]

    board[x][y] == BoardConstants.blank_space
  end

  def space_at(coords)
    board[coords.last][coords.first]
  end

  def random_direction
    DIRECTIONS.sample
  end

  def random_coord
    alpha = (Board::TOP_LABEL[1..board.length]).sample
    num = (1..board.length).to_a.sample
    
    alpha + num.to_s # => "A1"
  end

  def get_valid_start(coords=nil, ship, direction)
    coords = get_coords(random_coord) if coords.nil?
    return coords if valid_placement?(coords, ship, direction)

    new_coords = get_coords(random_coord)
    get_valid_start(new_coords, ship, direction)
  end

  def valid_placement?(coords,ship,direction)
    ship_fits_on_board?(coords, ship, direction) && room_for_ship?(coords, ship, direction)
  end

  def room_for_ship?(coords, ship, direction)
    horz_coord = coords[0]
    vert_coord = coords[1]
    
    if direction == "horizontal"
      current_row = row(vert_coord)
      ending = check_ship_length(horz_coord, ship.length)
      return current_row[horz_coord..ending].all? { |space| space == BoardConstants.blank_space }
    else
      current_column = column(horz_coord)
      ending = check_ship_length(vert_coord, ship.length)
      return current_column[vert_coord..ending].all? { |space| space == BoardConstants.blank_space }
    end
  end

  def ship_fits_on_board?(coords, ship, direction)
    checker = 0
    if direction == "horizontal"
      checker = check_ship_length(coords[0], ship.length)
    elsif direction == "vertical"
      checker = check_ship_length(coords[1], ship.length)
    end
    checker < 10
  end

  def row(coord)
    board[coord]
  end

  def column(coord)
    col = []
    index = 0
    until col.length == board.length
      col << board[index][coord]
      index += 1
    end
    col
  end

  def find_ship(ship_type)
    raise ShipError, ShipError.unknown_ship unless ShipConstants.acceptable_ships.include? ship_type
    ships.select { |ship| ship.name == ship_type }[0]
  end

  def get_coords(coord)
    raise InvalidCoordinateError, InvalidCoordinateError.standard(coord) unless coord.match(/\A[a-jA-J]\d{1,2}\z/) # e.g. "B5"; "C10"

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

  def stringify_coords(coords)
    horz_coord = coords[0] + 1
    vert_coord = coords[1] + 1

    Board::TOP_LABEL[horz_coord] + vert_coord.to_s
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

  def check_ship_length(start, ship_length) 
    start + (ship_length - 1) # so that the first space on the ship overlaps the start
  end
end


