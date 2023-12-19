# --- Day 11: Cosmic Expansion ---
# --- Part Two ---

# The galaxies are much older (and thus much farther apart) than the researcher
# initially estimated.

# Now, instead of the expansion you did before, make each empty row or column
# one million times larger. That is, each empty row should be replaced with
# 1000000 empty rows, and each empty column should be replaced with 1000000
# empty columns.

# (In the example above, if each empty row or column were merely 10 times
# (larger, the sum of the shortest paths between every pair of galaxies would be
# (1030. If each empty row or column were merely 100 times larger, the sum of
# (the shortest paths between every pair of galaxies would be 8410. However,
# (your universe will need to expand far beyond these values.)

# Starting with the same initial image, expand the universe according to these
# new rules, then find the length of the shortest path between every pair of
# galaxies. What is the sum of these lengths?


require_relative '../../utils/map.rb'

EXAMPLE0 =
"#..
#..
...
..#"


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


class TestMain < Minitest::Test
  def test_run
    assert_equal(374, Main.run!(EXAMPLE1, 2))
    assert_equal(1030, Main.run!(EXAMPLE1, 10))
    assert_equal(8410, Main.run!(EXAMPLE1, 100))
  end

  def test_find_distance
    assert_equal(9,  Main.find_distance([6, 1], [11, 5], 10, [3], [8]))
    assert_equal(42, Main.find_distance([0, 4], [10, 9], 10, [4, 8, 12], [1, 6]))
  end
  def test_valid_range
    assert_equal(1..4, Main.valid_range(1,4))
    assert_equal(-1..4, Main.valid_range(4,-1))
  end
end

class TestMap < Minitest::Test
  def test_expanded_rows
    map = Map.from_input(EXAMPLE0)
    rows = map.expanded_rows
    assert_equal([2],rows)

    map = Map.from_input(EXAMPLE1)
    rows = map.expanded_rows
    assert_equal([3,7],rows)
  end

  def test_expanded_columns
    map = Map.from_input(EXAMPLE0)
    columns = map.expanded_columns
    assert_equal([1],columns)

    map = Map.from_input(EXAMPLE1)
    columns = map.expanded_columns
    assert_equal([2,5,8],columns)
  end

end

class Main
  class << self
    def run!(input, expansion = 1_000_000)
      map = Map.from_input(input)
      galaxies = map.find_indexes("#")
      rows, cols = map.expanded_rows, map.expanded_columns
      distances = 0

      until galaxies.empty?
        study = galaxies.shift
        val = galaxies.inject(0) {|sum, g| sum + find_distance(study, g, expansion, rows, cols) }
        distances += val
      end
      distances
    end

    def find_distance(a, b, expansion, rows, cols)
      val = (a[0] - b[0]).abs + (a[1] - b[1]).abs
      val += rows.count{|row| valid_range(a[0], b[0]).include?(row) } * (expansion-1)
      val += cols.count{|col| valid_range(a[1], b[1]).include?(col) } * (expansion-1)
      val
    end

    def valid_range(a, b)
      ([a,b].min..[a,b].max)
    end
  end
end

class Map
  def expanded_columns
    self.transpose.expanded_rows
  end

  def expanded_rows
    # find rows that are all "."
    self.to_a.size.times.select {|i| rows[i].all? "." }
  end
end
