require_relative 'battleship.rb'

describe "Board" do
  let(:board){ Board.new }

  describe "#board" do
    it 'is an array of 10 arrays' do
      expect(board.board.all? { |row| row.class == Array }).to be(true)
      expect(board.board.length).to eq(10)
    end

    it 'has ten spaces per row' do
      expect(board.board.all? { |row| row.length == 10 }).to be(true)
    end
  end
end