
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
    rendered_board << first_row
    
    BOARD_LENGTH.times do |num|
      row_num = (num + 1).to_s
      if row_num.length == 1
        row_num = " " + row_num
      end
      rendered_board << (row_num.colorize(:yellow) + " ") + row(num).join(" ")
    end
    rendered_board.join("\n")
  end

  def row(coord)
    board[coord]
  end

  def column(coord)
    board.transpose[coord]
  end

  private

  def first_row
    TOP_LABEL.join(" ").colorize(:yellow)
  end

  def set_board
    new_board = []
    BOARD_LENGTH.times { new_board << Array.new(BOARD_LENGTH, BoardConstants.blank_space) }
    new_board
  end
end
