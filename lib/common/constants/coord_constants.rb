module CoordConstants
  def self.letter_coords
   { "A" => 0,
     "B" => 1,
     "C" => 2,
     "D" => 3,
     "E" => 4,
     "F" => 5,
     "G" => 6,
     "H" => 7,
     "I" => 8,
     "J" => 9 }
  end

  def self.acceptable_coord_lengths
   [2, 3]
  end
end