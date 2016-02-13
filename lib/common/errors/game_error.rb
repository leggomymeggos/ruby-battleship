class GameError < StandardError
  def self.dont_shoot
    "Where are you aiming? Try populating the board with ships."
  end

  def self.already_shot
    "That coordinate has already been hit."
  end
end