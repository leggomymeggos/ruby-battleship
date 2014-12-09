require_relative 'enemy_ai'

describe "EnemyAI" do
  let(:enemy){ EnemyAI.new }
  before(:each){ enemy.populate_board }

  it 'inherits from the Game class' do
    expect( enemy ).to be_a( Game::EnemyAI )
  end

  describe '#get_current_and_surrounding_coords' do
    it 'finds coordinates around given coord' do
      expect( enemy.get_current_and_surrounding_coords([3, 4]) ).to eq([[3, 4], [3, 3], [3, 5], [2, 4], [4, 4]] )
    end
  end

  describe '#find_hits' do
    before{ enemy.board[4][5] = Game::HIT 
            enemy.board[4][3] = Game::HIT
          }

    it 'finds hits around in the immediate vicinity of the coordinates' do
      expect( enemy.find_hits([4, 4]) ).to eq( [[3, 4], [5, 4]] )
    end
  end
end