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
    
    rendered_board << first_row.join(" ").colorize(:yellow)
    
    board.each.with_index(1) do |row, index|
      num = index.to_s
      if num.length == 1
        num = " " + num
      end
      rendered_board << (num.colorize(:yellow) + " ") + row.join(" ")
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
