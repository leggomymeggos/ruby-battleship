class InvalidDirectionError < StandardError
  def self.unknown_direction
    "Unknown direction. Please choose either \"horizontal\" or \"vertical\""
  end
end