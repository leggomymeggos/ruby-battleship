require_relative 'battleship'

describe "Battleship" do
  let(:battle){ Battleship.new }
  context "default mode" do

    it 'sets a home and enemy board on initialization' do
      expect(battle.home).not_to be nil
      expect(battle.send(:enemy)).not_to be nil
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

  context "hard mode" do
    let(:hard_battle){ Battleship.new(level: "hard") }

    it 'uses the ComputerAI class to set the home board' do
      expect( hard_battle.home.class ).to eq( ComputerAI )
    end

    describe '#shoot_home' do
      before(:each){ hard_battle.start }
      it 'chooses the AI\'s #smart_shot method' do
        allow(hard_battle.home).to receive(:smart_shot).and_return([[2, 1], [0, 1], [1, 2], [1, 0]])
        expect(hard_battle.shoot_home).to eq([[2, 1], [0, 1], [1, 2], [1, 0]])
      end
    end
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

  describe '#shoot_enemy' do
    before(:each){ |test| battle.start unless test.metadata[:broken] }
    it 'doesn\'t shoot if there are no ships on the board', broken: true do
      expect{ battle.shoot_enemy("A2") }.to raise_error( GameError )
    end

    it 'takes one argument' do
      expect( Battleship.instance_method(:shoot_enemy).arity ).to be 1
    end

    it 'raises an error if it is passed an invalid coordinate' do
      expect{ battle.shoot_enemy("90") }.to raise_error( InvalidCoordinateError )
    end

    it 'raises an error if it is passed a coordinate that has already been shot' do
      coord = battle.home.send(:random_coord)
      battle.shoot_enemy(coord)
      expect{ battle.shoot_enemy(coord) }.to raise_error( GameError )
    end
  end

  describe '#enemy_mock' do
    it 'returns a board, not a game' do
      expect( battle.enemy_mock.is_a? Board ).to be true
      expect( battle.enemy_mock.is_a? Game ).to be false
    end
  end

  describe '#update_enemy_mock' do
    before do
      battle.start
      coord = battle.home.send(:random_coord)
      battle.shoot_enemy(coord)
    end

    it 'updates the enemy mock board to reflect the shot' do
      expect{ battle.update_enemy_mock }.to change{ battle.enemy_mock.render }
    end
  end
end
