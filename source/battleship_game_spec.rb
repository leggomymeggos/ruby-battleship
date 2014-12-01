require_relative 'battleship.rb'

describe 'Game' do
  let(:game){ Game.new }

  it 'creates a board on initialization' do
    expect(game.board).not_to be nil
  end

  it 'creates ships on initialization' do
    expect(game.ships).not_to be nil
  end

  it 'creates five ships' do
    expect(game.ships.all? { |ship| ship.class == Ship }).to be true
    expect(game.ships.length).to eq(5)
  end

  describe '#place_ship' do
    xit 'takes three arguments' do
      
    end

    it 'raises an InvalidDirectionError if the direction doesn\'t make sense' do
      expect{ game.place_ship("Cruiser", "A1", "left") }.to raise_error( InvalidDirectionError )
    end

    it 'raises an InvalidCoordinateError if the coordinate doesn\'t make sense' do
      expect{ game.place_ship("Cruiser", "A11", "vertical") }.to raise_error( InvalidCoordinateError )
    end

    it 'raises a ShipError if the ship doesn\'t exist' do
      expect{ game.place_ship("Yacht", "A1", "vertical") }.to raise_error( ShipError )
    end

    it 'raises a ShipError if the ship has already been placed' do
      game.place_ship("Aircraft carrier", "A1", "vertical")
      expect{ game.place_ship("Aircraft carrier", "F4", "horizontal") }.to raise_error( ShipError )
    end
  end
end