# --- Day 4: Ceres Search ---

# This word search allows words to be horizontal, vertical, diagonal, written
# backwards, or even overlapping other words. It's a little unusual, though, as
# you don't merely need to find one instance of XMAS - you need to find all of
# them.

# The actual word search will be full of letters instead.

# Take a look at the little Elf's word search. How many times does XMAS appear?


EXAMPLE1 = <<~'EXAMPLE'
MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
          EXAMPLE


class TestMain < Minitest::Test
  def test_run
    assert_equal(9, Main.run!(EXAMPLE1))
  end
end

class Main
  class << self
    def run!(input)
      runner = self.from_input(input)
      runner.run!
    end

    def from_input(input)
      self.new(Map.from_input(input))
    end
  end

  DIRECTIONS = [
        Map::UP + Map::RIGHT,
        Map::UP + Map::LEFT,
        Map::DOWN + Map::RIGHT,
        Map::DOWN + Map::LEFT]

  attr_reader :map, :as
  def initialize(map)
    @map = map
    @as = map.find_indexes('A').map {|pos| Vector[*pos] }
  end

  def run!
    as.count {|a| test_for_x_mas(a) }
  end

  def test_for_x_mas(a)
    return false if DIRECTIONS.any? {|dir| map.outside_bounds?(a+dir) }
    diag = [map[a + Map::UP + Map::RIGHT], map[a + Map::DOWN + Map::LEFT]]
    return false unless diag.include?("M") && diag.include?("S")
    diag = [map[a + Map::UP + Map::LEFT], map[a + Map::DOWN + Map::RIGHT]]
    return false unless diag.include?("M") && diag.include?("S")
    return true
  end
end
