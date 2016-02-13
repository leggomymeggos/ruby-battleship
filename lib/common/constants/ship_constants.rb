module ShipConstants
  def self.ship_hash
    { "Aircraft carrier" => { abbr: "A", length: 5, name: "Aircraft carrier", placed: false },
      "Battleship"       => { abbr: "B", length: 4, name: "Battleship", placed: false },
      "Submarine"        => { abbr: "S", length: 3, name: "Submarine", placed: false },
      "Cruiser"          => { abbr: "C", length: 3, name: "Cruiser", placed: false },
      "Destroyer"        => { abbr: "D", length: 2, name: "Destroyer", placed: false }
    }
  end

  def self.acceptable_ships
    [ "Aircraft carrier", "Battleship", "Submarine", "Cruiser", "Destroyer" ]
  end
end