require 'colorize'

module BoardConstants
  def self.blank_space
    "+".colorize(:cyan)
  end
end
