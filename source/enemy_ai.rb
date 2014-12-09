require_relative 'game'

class EnemyAI < Game
  def initialize
    super
    @next_coord = next_coord
  end

  def next_coord
    @next_coord ||= Array.new
  end

  def get_current_and_surrounding_coords(coords) # there has to be a better way to do this...
    to_shoot = []
    x = coords.first
    y = coords.last

    to_shoot << [x, y]
    to_shoot << [x, (y - 1)]
    to_shoot << [x, (y + 1)]
    to_shoot << [(x - 1), y]
    to_shoot << [(x + 1), y]
    
    to_shoot
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

  def smart_shot
    if next_coord.empty?
      shot = random_coord
      
      shot_value = shoot(shot)

      repopulate_next_coord(shot) if shot_hit?(shot_value)
    else
      shoot(next_coord.pop)
    end
  end

  def repopulate_next_coord(shot)
    coord = get_coords(shot)
    @next_coord = find_hits(coord)
  end
end