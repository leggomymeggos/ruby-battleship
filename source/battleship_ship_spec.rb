require_relative 'battleship.rb'

describe "Ship" do 
  let(:aircraft_carrier){ Ship.new("Aircraft carrier") }
  let(:battleship){ Ship.new("Battleship") }
  let(:submarine){ Ship.new("Submarine") }
  let(:cruiser){ Ship.new("Cruiser") }
  let(:destroyer){ Ship.new("Destroyer") }

  it 'has an associated length' do
    expect(aircraft_carrier.length).to be(5)
    expect(battleship.length).to be(4)
    expect(submarine.length).to be(3)
    expect(cruiser.length).to be(3)
    expect(destroyer.length).to be(2)
  end

  it 'has a name' do
    expect(aircraft_carrier.name).to eq("Aircraft carrier")
    expect(battleship.name).to eq("Battleship")
    expect(submarine.name).to eq("Submarine")
    expect(cruiser.name).to eq("Cruiser")
    expect(destroyer.name).to eq("Destroyer")
  end

  it 'has an abbreviated character' do
    expect(aircraft_carrier.abbr).not_to be nil
    expect(battleship.abbr).not_to be nil
    expect(submarine.abbr).not_to be nil
    expect(cruiser.abbr).not_to be nil
    expect(destroyer.abbr).not_to be nil
  end
end