require_relative 'computer_ai'

describe "ComputerAI" do
  let(:computer){ ComputerAI.new }
  before(:each){ computer.populate_board }

  it 'inherits from the Game class' do
    expect( computer ).to be_a( Game::ComputerAI )
  end

  describe '#get_current_and_surrounding_coords' do
    it 'finds coordinates around given coord' do
      expect( computer.get_current_and_surrounding_coords([3, 4]) ).to eq([[3, 4], [3, 3], [3, 5], [2, 4], [4, 4]] )
    end
  end

  describe '#find_hits' do
    before{ computer.board[4][5] = Game::HIT
            computer.board[4][3] = Game::HIT
          }

    it 'finds hits around in the immediate vicinity of the coordinates' do
      expect( computer.find_hits([4, 4]) ).to eq( ["D5", "F5"] )
    end
  end
end