require_relative 'game'

class ComputerAI < Game
  def initialize
    super
    @next_coord = next_coord
  end

  def next_coord
    @next_coord ||= Array.new
  end

  def get_surrounding_coords(coords) # there has to be a better way to do this...
    to_shoot = []
    x = coords.first
    y = coords.last

    to_shoot << [x, (y - 1)] unless y == 0
    to_shoot << [x, (y + 1)] unless y >= board.length
    to_shoot << [(x - 1), y] unless x == 0
    to_shoot << [(x + 1), y] unless x >= board.length
    
    to_shoot
  end

  def stringify_surrounding_coords(coord_collection)
    coord_collection.map( |coord| stringify_coords(coord) )
  end

  def find_hits(coords)
    hits_here = []
    get_current_and_surrounding_coords(coords).each do |coord|
      if space_at(coord) == Game::HIT
        hits_here << coord
      end
    end
    hits_here
  end

  def already_tried?(coord)
    shot_coords.include? coord
  end

  def shot_hit?(board_value)
    board_value == HIT
  end

  def get_valid_shot
    shot = random_coord
    until !already_tried? shot
      shot = random_coord
    end
    shot
  end

  def smart_shot
    if next_coord.empty?
      shot = get_valid_shot
      
      shot_value = shoot(shot)

      repopulate_next_coord(shot) if shot_hit?(shot_value)
    else
      shoot(next_coord.pop)
    end
  end

  def repopulate_next_coord(shot)
    @next_coord = new_valid_shots(shot)
  end

  def new_valid_shots(shot)
    coord = get_coords(shot)
    get_surrounding_coords(coord).select{ |shots| !already_tried? shots }
  end
end