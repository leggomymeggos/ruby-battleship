require 'spec_helper'

describe "ComputerAI" do
  let(:computer){ ComputerAI.new }
  before(:each){ computer.populate_board }

  it 'inherits from the Game class' do
    expect( computer.class.superclass ).to be( Game )
  end

  describe '#get_surrounding_coords' do
    it 'finds coordinates around given coord' do
      expect( computer.get_surrounding_coords([3, 4]) ).to eq([ [3, 3], [3, 5], [2, 4], [4, 4]] )
    end

    it 'doesn\'t include coordinates that are off the board' do
      expect( computer.get_surrounding_coords([0, 0]) ).not_to include([-1, 0], [0, -1])
      expect( computer.get_surrounding_coords([9, 9]) ).not_to include([9, 10], [10, 9])
      expect( computer.get_surrounding_coords([7, 9]) ).not_to include([7, 10])
      expect( computer.get_surrounding_coords([9, 4]) ).not_to include([10, 4])
    end
  end

  describe '#find_hits' do
    before{ computer.board[4][5] = Game::HIT
            computer.board[4][3] = Game::HIT
          }

    it 'finds hits around in the immediate vicinity of the coordinates' do
      expect( computer.find_hits([4, 4]) ).to eq( [[3, 4], [5, 4]] )
    end
  end

  describe '#smart_shot' do
    it 'updates #next_coord' do
      expect(computer.smart_shot).to eq(computer.next_coord)
    end
  end

  describe '#new_valid_shots' do
    it 'returns a list of coordinates surrounding a starting point' do
      expect( computer.new_valid_shots("B3") ).to eq(["B2", "B4", "A3", "C3"])
    end

    it 'doesn\'t list coordinates that have already been hit' do
      computer.shot_coords << "B4"
      expect( computer.new_valid_shots("B3") ).not_to include("B4")
    end
  end

  describe '#get_valid_shot' do
    it 'returns a string coordinate' do
      expect( computer.get_valid_shot ).to match(/\A[a-jA-J]\d{1,2}\z/)
    end
  end
end