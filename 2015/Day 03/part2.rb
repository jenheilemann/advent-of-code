# --- Day 3: Perfectly Spherical Houses in a Vacuum ---
# --- Part Two ---

# The next year, to speed up the process, Santa creates a robot version of
# himself, Robo-Santa, to deliver presents with him.

# Santa and Robo-Santa start at the same location (delivering two presents to
# the same starting house), then take turns moving based on instructions from
# the elf, who is eggnoggedly reading from the same script as the previous year.

# This year, how many houses receive at least one present?

require 'set'

class TestMain < Minitest::Test
  def test_run
    assert_equal(3, Main.run!('^v'))
    assert_equal(3, Main.run!('^>v<'))
    assert_equal(11, Main.run!('^v^v^v^v^v'))
  end
end

class Main
  Arrow_to_vec = {
    '^' => Map::UP, '>' => Map::RIGHT, '<' => Map::LEFT, 'v' => Map::DOWN
  }
  class << self
    def run!(input)
      houses = Set.new
      santa = robo = Vector[0,0]
      houses << santa
      input.strip.split('').each_slice(2) do |dirs|
        santa = santa + Arrow_to_vec[dirs[0]]
        robo = robo + Arrow_to_vec[dirs[1]]
        houses << santa
        houses << robo
      end
      houses.length
    end
  end
end
