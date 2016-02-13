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