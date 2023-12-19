# --- Day 14: Parabolic Reflector Dish ---

# In short: if you move the rocks, you can focus the dish. The platform even has
# a control panel on the side that lets you tilt it in one of four directions!
# The rounded rocks (O) will roll when the platform is tilted, while the
# cube-shaped rocks (#) will stay in place. You note the positions of all of the
# empty spaces (.) and rocks (your puzzle input).

# You notice that the support beams along the north side of the platform are
# damaged; to ensure the platform doesn't collapse, you should calculate the
# total load on the north support beams.

# The amount of load caused by a single rounded rock (O) is equal to the number
# of rows from the rock to the south edge of the platform, including the row the
# rock is on. (Cube-shaped rocks (#) don't contribute to load.) The total load
# is the sum of the load caused by all of the rounded rocks.

# Tilt the platform so that the rounded rocks all roll north. Afterward, what is
# the total load on the north support beams?


EXAMPLE1 = "
O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#...."

AFTER_ROLL = "
OOOO.#.O..
OO..#....#
OO..O##..O
O..#.OO...
........#.
..#....#.#
..O..#.O.O
..O.......
#....###..
#....#...."


class TestMain < Minitest::Test
  def test_run
    assert_equal(136, Main.run!(EXAMPLE1))
  end
end

class TestTiltyTable < Minitest::Test
  def test_from_input
    table = TiltyTable.from_input(EXAMPLE1)
    assert_kind_of TiltyTable, table
    assert_equal 18, table.rolly.length
    assert_equal 17, table.unmoving.length
    assert_equal Position.new(x: 0, y: 0), table.rolly[[0,0]]
    assert_equal Position.new(x: 5, y: 0), table.unmoving[[5,0]]
    assert_equal 10, table.height
    assert_equal 10, table.width
  end

  def test_off_edge?
    table = TiltyTable.from_input(EXAMPLE1)
    assert table.off_edge?(Position.new(x: -1,y:  0))
    assert table.off_edge?(Position.new(x: 0, y: -1))
    assert table.off_edge?(Position.new(x: 0, y: 10))
    assert table.off_edge?(Position.new(x: 10,y:  0))

    refute table.off_edge?(Position.new(x: 0, y: 0))
    refute table.off_edge?(Position.new(x: 0, y: 9))
    refute table.off_edge?(Position.new(x: 9, y: 0))
    refute table.off_edge?(Position.new(x: 9, y: 9))
  end

  def test_impassible?
    table = TiltyTable.from_input(EXAMPLE1)
    refute table.impassible?(Position.new(x: 0, y:2))
    refute table.impassible?(Position.new(x: 2, y:2))
    assert table.impassible?(Position.new(x: 0, y:0))
    assert table.impassible?(Position.new(x: -1,y: 0))
    assert table.impassible?(Position.new(x: 0, y:10))
    assert table.impassible?(Position.new(x: 1, y:4))
    assert table.impassible?(Position.new(x: 0, y:1))
  end

  def test_roll
    table = TiltyTable.from_input(EXAMPLE1)
    assert_equal Position.new(x: 1, y: 9), table.rolly[[1,9]]

    table.roll!(Map::UP)
    assert_equal Position.new(x: 0, y: 0), table.rolly[[0,0]]
    assert_equal Position.new(x: 1, y: 0), table.rolly[[1,0]]
    assert_equal Position.new(x: 2, y: 0), table.rolly[[2,0]]
    assert_equal Position.new(x: 3, y: 0), table.rolly[[3,0]]
    assert_equal Position.new(x: 0, y: 1), table.rolly[[0,1]]
    assert_equal Position.new(x: 0, y: 2), table.rolly[[0,2]]
    assert_equal Position.new(x: 0, y: 3), table.rolly[[0,3]]

    assert_nil table.rolly[[1,9]] # it moved!
  end

  def test_weight_distribution
    table = TiltyTable.from_input(EXAMPLE1)
    assert_equal 104, table.weight_distribution
    table.roll!(Map::UP)

    assert_equal 136, table.weight_distribution
  end
end

class Main
  class << self
    def run!(input)
      tilty_table = TiltyTable.from_input(input)
      tilty_table.roll!(Map::UP)
      tilty_table.weight_distribution
    end
  end
end

TiltyTable = Struct.new(:rolly, :unmoving, :height, :width, keyword_init: true) do
  def self.from_input(input)
    rolly_rocks = {}
    unmoving_rocks = {}

    rows = input.strip.split("\n")
    rows.each_with_index do |str, row|
      str.chars.each_with_index do |s, col|
        case s
        when "."
        when "#"
          unmoving_rocks[[col, row]] = Position.new(x: col, y: row)
        when "O"
          rolly_rocks[[col, row]] = Position.new(x: col, y: row)
        end
      end
    end
    w = rows.length
    h = rows[0].length
    new(rolly: rolly_rocks, unmoving: unmoving_rocks, height: h, width: w)
  end

  def weight_distribution
    rolly.values.inject(0) {|sum, pos| sum + height - pos.y }
  end

  def roll!(dir)
    rolling_now = rolly
    self.rolly = {}

    rolling_now.each do |k, rock|
      until impassible?(Position.from_vector(rock + dir))
        rock = rock + dir
      end
      rolly[rock.to_a] = Position.from_vector rock
    end
  end

  def impassible? pos
    return true if off_edge?(pos)
    return true unless unmoving[pos.to_a].nil?
    return true unless rolly[pos.to_a].nil?
    false
  end

  def off_edge? pos
    pos.x < 0 || pos.y < 0 || pos.x > (width - 1)|| pos.y > (height - 1)
  end
end
