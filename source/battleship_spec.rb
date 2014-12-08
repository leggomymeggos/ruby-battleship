require_relative 'battleship.rb'

describe "Battleship" do
  let(:battle){ Battleship.new }

  it 'sets a home and enemy board on initialization' do
    expect(battle.home).not_to be nil
    expect(battle.send(:enemy)).not_to be nil
  end

  describe '#start' do
    it 'populates the home board' do
      expect{ battle.start }.to change{ battle.home.board.to_s }
      expect( battle.home.send(:no_more_ships) ).to be false
    end

    it 'populates the enemy board' do
      expect{ battle.start }.to change{ battle.send(:enemy).board.to_s }
      expect( battle.send(:enemy).send(:no_more_ships) ).to be false
    end
  end

  describe '#enemy_mock' do
    it 'returns a board, not a game' do
      expect( battle.enemy_mock.is_a? Board ).to be true
      expect( battle.enemy_mock.is_a? Game ).to be false
    end
  end

  describe '#shoot_enemy' do
    before{ battle.start }
    it 'takes one argument' do
      expect( Battleship.instance_method(:shoot_enemy).arity ).to be 1
    end

    it 'raises an error if it is passed an invalid coordinate' do
      expect{ battle.shoot_enemy("90") }.to raise_error( InvalidCoordinateError )
    end

    it 'updates the enemy mock board to reflect the shot' do
      expect{ battle.shoot_enemy("A1") }.to change{ battle.enemy_mock.render }
    end
  end

  describe '#shoot_home' do
    before{ battle.start }
    it 'takes zero arguments' do
      expect( Battleship.instance_method(:shoot_home).arity ).to be 0
    end

    it 'updates the home board to reflect the shot' do
      expect{ battle.shoot_home }.to change{ battle.home.to_s }
    end
  end
end