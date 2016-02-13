require 'spec_helper'

describe 'Game' do
  let(:game){ Game.new }
  let(:ac){ Ship.new("Aircraft carrier") }
  let(:bs){ Ship.new("Battleship") }
  let(:sub){ Ship.new("Submarine") }
  let(:cr){ Ship.new("Cruiser") }
  let(:dtr){ Ship.new("Destroyer") }

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

  describe '#populate_board' do
    before(:each){ game.populate_board }

    it 'places ships on the board' do
      expect( game.ships.all? { |ship| ship.placed } ).to be true
    end

    it 'updates the board with ships' do
      expect( game.board.flatten ).to include(ac.abbr, bs.abbr, sub.abbr, cr.abbr, dtr.abbr)
    end

    it 'doesn\'t try to place ships on top of one another, populate with an invalid coordinate, or choose an invalid direction' do
      game2 = Game.new
      expect{ game2.populate_board }.not_to raise_error
      game3 = Game.new
      expect{ game3.populate_board }.not_to raise_error
      game4 = Game.new
      expect{ game4.populate_board }.not_to raise_error
      game5 = Game.new
      expect{ game5.populate_board }.not_to raise_error
      game6 = Game.new
      expect{ game6.populate_board }.not_to raise_error
      game7 = Game.new
      expect{ game7.populate_board }.not_to raise_error
    end

    it 'randomly populates the board' do
      game2 = Game.new
      game2.populate_board
      expect( game.board ).not_to eq( game2.board ) # This has the chance of failing every once in a while because it's random. Run the test again to see if it's failing consistently.
    end
  end

  describe '#place_ship' do
    it 'takes three arguments' do
      expect(Game.instance_method(:place_ship).arity).to eq(3)
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

    it 'doesn\'t allow ships to be placed on top of one another' do
      game.place_ship("Aircraft carrier", "A1", "vertical")
      expect{ game.place_ship("Cruiser", "A2", "horizontal") }.to raise_error( ShipError )
    end
  end

  describe '#shoot' do
    before(:each){ |test| game.populate_board unless test.metadata[:broken] }

    it 'updates the board to reflect a hit or miss' do
      game.shoot("C1")
      expect( game.board[0][2] ).not_to include( BoardConstants.blank_space )
    end

    it 'doesn\'t let the user fire at a board when the game hasn\'t been started', broken: true do
      expect{ game.shoot("C1") }.to raise_error( GameError )
    end
  end

  describe '#find_ship' do
    it 'is a private method' do
      expect{ game.find_ship("Battleship") }.to raise_error( NoMethodError )
    end

    it 'returns a ship object' do
      expect( game.send(:find_ship, "Battleship").is_a? Ship ).to be true
    end

    it 'returns the correct ship object' do
      expect( game.send(:find_ship, "Battleship").name ).to eq("Battleship")
    end
  end

  describe '#random_coord' do
    it 'returns a random lettered coordinate' do
      expect( game.send(:random_coord) ).to match(/\A[a-jA-J]\d{1,2}\z/) # e.g. "B5"; "C10"
    end
  end

  describe '#get_coords' do
    it 'is a private method' do
      expect{ game.get_coords("A1") }.to raise_error( NoMethodError )
    end

    it 'converts letter coordinates into numbered coordinates' do
      expect( game.send(:get_coords, "E8") ).to eq([4, 7])
    end
  end

  describe '#stringify_coords' do
    it 'converts numbered coordinates into letter coordinates' do
      expect( game.send(:stringify_coords, [9, 1]) ).to eq("J2")
    end
  end
end
