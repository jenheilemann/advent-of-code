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
    assert_equal(18, Main.run!(EXAMPLE1))
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

  DIRECTIONS = Map::DIRECTIONS + [
        Map::UP + Map::RIGHT,
        Map::UP + Map::LEFT,
        Map::DOWN + Map::RIGHT,
        Map::DOWN + Map::LEFT]

  attr_reader :map, :xes
  def initialize(map)
    @map = map
    @xes = map.find_indexes('X').map {|pos| Vector[*pos] }
  end

  def run!
    xes.map {|x| test_for_xmas(x) }.sum
  end

  def test_for_xmas(x)
    xm = DIRECTIONS.filter {|dir| !map.outside_bounds?(x+dir) && map[x+dir] == "M"}
    xma = xm.filter {|dir| !map.outside_bounds?(x+dir+dir) && map[x+dir+dir] == "A"}
    xmas = xma.filter {|dir| !map.outside_bounds?(x+dir+dir+dir) && map[x+dir+dir+dir] == "S"}
    xmas.length
  end
end
