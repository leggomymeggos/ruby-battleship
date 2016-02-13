
class Ship
  include ShipConstants

  attr_reader :ship

  def initialize(ship_name)
    @ship = set_ship(ship_name)
  end

  def length
    ship[:length]
  end

  def name
    ship[:name]
  end

  def abbr
    ship[:abbr]
  end

  def placed
    ship[:placed]
  end

  def placed=(arg)
    acceptable = [true, false]
    raise UpdateError, UpdateError.standard unless acceptable.include? arg
    ship[:placed] = arg
  end

  private

  def set_ship(ship_name)
    @ship ||= ShipConstants.ship_hash[ship_name]
  end
end
