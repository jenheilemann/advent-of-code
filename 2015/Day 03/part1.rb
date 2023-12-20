# --- Day 3: Perfectly Spherical Houses in a Vacuum ---

# He begins by delivering a present to the house at his starting location, and
# then an elf at the North Pole calls him via radio and tells him where to move
# next. Moves are always exactly one house to the north (^), south (v), east
# (>), or west (<). After each move, he delivers another present to the house at
# his new location.

# Santa ends up visiting some houses more than once. How many houses receive at
# least one present?

require 'set'

class TestMain < Minitest::Test
  def test_run
    assert_equal(2, Main.run!('>'))
    assert_equal(4, Main.run!('^>v<'))
    assert_equal(2, Main.run!('^v^v^v^v^v'))
  end
end

class Main
  Arrow_to_vec = {
    '^' => Map::UP, '>' => Map::RIGHT, '<' => Map::LEFT, 'v' => Map::DOWN
  }
  class << self
    def run!(input)
      houses = Set.new
      current = Vector[0,0]
      houses << current
      input.strip.split('').each do |dir|
        current = current + Arrow_to_vec[dir]
        houses << current
      end
      houses.length
    end
  end
end
