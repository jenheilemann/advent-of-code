# --- Day 11: Cosmic Expansion ---

# The researcher has collected a bunch of data and compiled the data into a
# single giant image (your puzzle input). The image includes empty space (.) and
# galaxies (#).

# The researcher is trying to figure out the sum of the lengths of the shortest
# path between every pair of galaxies. However, there's a catch: the universe
# expanded in the time it took the light from those galaxies to reach the
# observatory.

# Due to something involving gravitational effects, only some space expands. In
# fact, the result is that any rows or columns that contain no galaxies should
# all actually be twice as big.

# Expand the universe, then find the length of the shortest path between every
# pair of galaxies. What is the sum of these lengths?

require_relative '../../utils/map.rb'

EXAMPLE0 =
"#..
#..
...
..#"
EXAMPLE0_EXPANDED =
"#...
#...
....
....
...#"


EXAMPLE1 =
"...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#....."

EXAMPLE1_EXPANDED =
"....#........
.........#...
#............
.............
.............
........#....
.#...........
............#
.............
.............
.........#...
#....#......."

class TestMain < Minitest::Test
  def test_run
    assert_equal(374, Main.run!(EXAMPLE1))
    assert_equal(14, Main.run!(EXAMPLE0))
  end

  def test_find_distance
    assert_equal(9, Main.find_distance([6, 1], [11, 5]))
    assert_equal(15, Main.find_distance([0, 4], [10, 9]))
    assert_equal(17, Main.find_distance([2, 0], [7, 12]))
    assert_equal(5, Main.find_distance([11, 0], [11, 5]))
  end
end

class TestMap < Minitest::Test

  def test_expand_universe
    map = Map.from_input(EXAMPLE0)
    example = Map.from_input(EXAMPLE0_EXPANDED)
    new_map = map.expand
    assert_equal(example,new_map)

    map = Map.from_input(EXAMPLE1)
    example = Map.from_input(EXAMPLE1_EXPANDED)
    new_map = map.expand
    assert_equal(example,new_map)
  end
end

class Main
  class << self
    def run!(input)
      map = Map.from_input(input)
      map = map.expand
      galaxies = map.find_indexes("#")
      distances = 0

      until galaxies.empty?
        studying = galaxies.shift
        distances += galaxies.inject(0) { |sum, g| sum + find_distance(g, studying) }
      end
      distances
    end

    def find_distance(a, b)
      (a[0] - b[0]).abs + (a[1] - b[1]).abs
    end
  end
end

class Map
  def expand
    temp = self.expand_vertically.transpose
    temp.expand_vertically.transpose
  end

  def expand_vertically
    # find rows that are all "."
    rows = self.to_a
    indices = rows.size.times.select {|i| rows[i].all? "." }
    indices.each_with_index{ |i, idx| rows.insert(i+idx, rows[i+idx]) }

    self.class[*rows]
  end
end
