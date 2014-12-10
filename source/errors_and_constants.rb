require 'colorize'
require 'coveralls'

class InvalidCoordinateError < StandardError
  def self.not_on_board
    "That is not on the board!"
  end

  def self.standard(coord)
    "#{coord} is an invalid coordinate. Please enter a coordinate in this format: \"A10\"" 
  end

  def self.invalid_start
    "That is not a valid starting point for that ship. Please try again."
  end
end

class InvalidDirectionError < StandardError
  def self.unknown_direction
    "Unknown direction. Please choose either \"horizontal\" or \"vertical\""
  end
end

class ShipError < StandardError
  def self.unknown_ship
    "Unknown ship. Please choose either \"Aircraft carrier\", \"Battleship\", \"Submarine\", \"Cruiser\", or \"Destroyer\""
  end

  def self.already_placed 
    "That ship is already on the board. Please try a different ship."
  end

  def self.space_taken
    "That space is already taken. Please try placing your ship somewhere else."
  end
end

class GameError < StandardError
  def self.dont_shoot
    "Where are you aiming? Try populating the board with ships."
  end

  def self.already_shot
    "That coordinate has already been hit."
  end
end

class UpdateError < StandardError
  def self.standard
    "That cannot be updated in that way."
  end
end

module ShipConstants
  def self.ship_hash
    { "Aircraft carrier" => { abbr: "A", length: 5, name: "Aircraft carrier", placed: false }, 
      "Battleship"       => { abbr: "B", length: 4, name: "Battleship", placed: false },
      "Submarine"        => { abbr: "S", length: 3, name: "Submarine", placed: false },
      "Cruiser"          => { abbr: "C", length: 3, name: "Cruiser", placed: false },
      "Destroyer"        => { abbr: "D", length: 2, name: "Destroyer", placed: false }
    }
  end

  def self.acceptable_ships
    [ "Aircraft carrier", "Battleship", "Submarine", "Cruiser", "Destroyer" ]
  end
end

module CoordConstants
  def self.letter_coords 
   { "A" => 0,
     "B" => 1,
     "C" => 2,
     "D" => 3,
     "E" => 4,
     "F" => 5,
     "G" => 6,
     "H" => 7,
     "I" => 8,
     "J" => 9 }
  end

  def self.acceptable_coord_lengths
   [2, 3]
  end
end

module BoardConstants
  def self.blank_space
    "+".colorize(:cyan)
  end
end
