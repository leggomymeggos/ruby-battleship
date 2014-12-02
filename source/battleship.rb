require_relative 'errors_and_constants.rb'

class Board
  include BoardConstants

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
    BOARD_LENGTH.times { new_board << Array.new(BOARD_LENGTH, BoardConstants.blank_space) }
    new_board
  end
end

class Ship
  include ShipConstants
                 
  attr_reader :ship

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

  def placed=(arg)
    acceptable = [true, false]
    raise UpdateError, UpdateError.standard unless acceptable.include? arg
    ship[:placed] = arg
  end

  private

  def set_ship(ship_hopeful)
    @ship ||= ShipConstants.ship_hash[ship_hopeful]
  end
end

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
    x = coord[1]
    y = coord[0]
    if hit?(coord)
      board[x][y] = HIT
    else
      board[x][y] = MISS
    end
  end

  def populate_board
    until ships.all? { |ship| ship.placed == true }
      auto_populate_board
    end
  end

  def place_ship(ship_type, coords, direction)
    raise InvalidDirectionError, InvalidDirectionError.unknown_direction unless DIRECTIONS.include? direction

    ship = find_ship(ship_type)
    raise ShipError, ShipError.already_placed if ship.placed == true

    starting_position = get_coords(coords)
    raise ShipError, ShipError.space_taken unless room_for_ship?(starting_position, ship, direction)
    
    #####################
    # BEGIN SMELLY CODE #

    horz_coord = starting_position[0]
    vert_coord = starting_position[1]

    
    if ship_fits_on_board?(starting_position, ship, direction)
      if direction == "horizontal"
        ending = horz_coord + (ship.length - 1)

        until horz_coord > ending
          board[vert_coord][horz_coord] = ship.abbr
          horz_coord += 1
        end

      elsif direction == "vertical"

        ending = vert_coord + (ship.length - 1)
        
        until vert_coord > ending
          board[vert_coord][horz_coord] = ship.abbr
          vert_coord += 1
        end
      end
    end
   

    # END SMELLY CODE   #
    #####################

    ship.placed = true

  end

  private

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


  def find_room(coords, ship, direction)
    new_coords = get_valid_start(coords, direction, ship)
    puts "Now I am trying to place #{ship.name} at: #{new_coords}"
    return new_coords
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

  def check_ship_length(start, ship_length) 
    start + (ship_length - 1) # so that the first space on the ship overlaps the start
  end

  def get_valid_start_coords(ship, direction)
    coords = get_coords(random_coord)
    puts "I am trying to place #{ship.name} at: #{coords}"

    if !ship_fits_on_board?(coords, ship, direction) || !room_for_ship?(coords, ship, direction)
      return find_room(coords, ship, direction)
    end
    coords
  end

  def get_valid_start(coords, direction, ship)
    if ship_fits_on_board?(coords, ship, direction) && room_for_ship?(coords, ship, direction)
      puts coords.inspect
      return coords
    end

    new_coords = get_coords(random_coord)
    get_valid_start(new_coords, direction, ship)
  end

  def auto_populate_board
    ships.each do |ship| 
      direction = random_direction
      
      next if ship.placed == true
      
      coords = get_valid_start_coords(ship, direction)
          
      strung_coords = stringify_coords(coords)
      
      place_ship(ship.name, strung_coords, direction)
    end
  end

  def random_coord
    alpha = (Board::TOP_LABEL[1..board.length]).sample
    num = (1..board.length).to_a.sample
    puts alpha + num.to_s
    alpha + num.to_s # => "A1"
  end

  def random_direction
    way_to_go = DIRECTIONS.sample
    puts way_to_go
    way_to_go
  end

  def hit?(coord)
    !empty_space?(coord)
  end

  def empty_space?(coord) # => [0, 0]
    x = coord[1]
    y = coord[0]

    board[x][y] == BoardConstants.blank_space
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
    found = ships.select { |ship| ship.name == ship_type }[0]
    found
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
end


