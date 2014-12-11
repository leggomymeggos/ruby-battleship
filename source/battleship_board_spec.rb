require_relative 'board_and_ship'
require 'coveralls'
Coveralls.wear!

describe "Board" do
  let(:board){ Board.new }

  it 'sets the board on initialization' do
    expect(board.board).not_to be nil
  end

  describe "#board" do
    it 'is an array of 10 arrays' do
      expect(board.board.all? { |row| row.class == Array }).to be true 
      expect(board.board.length).to eq(10)
    end

    it 'has ten spaces per row' do
      expect(board.board.all? { |row| row.length == 10 }).to be true
    end

    it 'is a square board' do
      expect(board.board.all? { |row| row.length == board.board.length }).to be true
    end
  end
end