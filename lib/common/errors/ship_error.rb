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
