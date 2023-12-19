# --- Day 14: Parabolic Reflector Dish ---
# --- Part Two ---

# The parabolic reflector dish deforms, but not in a way that focuses the beam.
# To do that, you'll need to move the rocks to the edges of the platform.
# Fortunately, a button on the side of the control panel labeled "spin cycle"
# attempts to do just that!

# Each cycle tilts the platform four times so that the rounded rocks roll north,
# then west, then south, then east. After each tilt, the rounded rocks roll as
# far as they can before the platform tilts in the next direction. After one
# cycle, the platform will have finished rolling the rounded rocks in those four
# directions in that order.

# This process should work if you leave it running long enough, but you're still
# worried about the north support beams. To make sure they'll survive for a
# while, you need to calculate the total load on the north support beams after
# 1000000000 cycles.

# Run the spin cycle for 1000000000 cycles. Afterward, what is the total load on
# the north support beams?


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

AFTER_1_CYCLE = "
.....#....
....#...O#
...OO##...
.OO#......
.....OOO#.
.O#...O#.#
....O#....
......OOOO
#...O###..
#..OO#...."

AFTER_2_CYCLES = "
.....#....
....#...O#
.....##...
..O#......
.....OOO#.
.O#...O#.#
....O#...O
.......OOO
#..OO###..
#.OOO#...O"

AFTER_3_CYCLES = "
.....#....
....#...O#
.....##...
..O#......
.....OOO#.
.O#...O#.#
....O#...O
.......OOO
#...O###.O
#.OOO#...O"

EXAMPLE0 = "
.....
..#..
.O...
..O.."

class TestMain < Minitest::Test
  def test_run
    assert_equal(64, Main.run!(EXAMPLE1))
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

    table = TiltyTable.from_input(EXAMPLE0)
    assert_equal 5, table.width
    assert_equal 4, table.height
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
    assert_equal Position.new(x: 3, y: 0), table.rolly[[3,0]]
    assert_equal Position.new(x: 0, y: 3), table.rolly[[0,3]]

    assert_nil table.rolly[[1,9]] # it moved!

    table = TiltyTable.from_input(EXAMPLE0)
    refute_nil table.rolly[[1,2]]
    refute_nil table.rolly[[2,3]]
    assert_equal 2, table.rolly.length
    table.roll!(Map::RIGHT)
    assert_equal Position.new(x: 4, y: 2), table.rolly[[4,2]]
    assert_equal Position.new(x: 4, y: 3), table.rolly[[4,3]]
    assert_equal 2, table.rolly.length
    table.roll!(Map::DOWN)
    assert_equal Position.new(x: 4, y: 2), table.rolly[[4,2]]
    assert_equal Position.new(x: 4, y: 3), table.rolly[[4,3]]
    assert_equal 2, table.rolly.length
    table.roll!(Map::LEFT)
    assert_equal Position.new(x: 0, y: 2), table.rolly[[0,2]]
    assert_equal Position.new(x: 0, y: 3), table.rolly[[0,3]]
    assert_equal 2, table.rolly.length
    table.roll!(Map::UP)
    assert_equal Position.new(x: 0, y: 0), table.rolly[[0,0]]
    assert_equal Position.new(x: 0, y: 1), table.rolly[[0,1]]
    assert_equal 2, table.rolly.length
  end

  def test_cycle
    table = TiltyTable.from_input(EXAMPLE1)
    after1 = TiltyTable.from_input(AFTER_1_CYCLE)
    after2 = TiltyTable.from_input(AFTER_2_CYCLES)
    after3 = TiltyTable.from_input(AFTER_3_CYCLES)

    table.cycle!
    assert_equal after1.rolly.keys.sort, table.rolly.keys.sort
    assert_equal after1.weight_distribution, table.weight_distribution
    table.cycle!
    assert_equal after2.weight_distribution, table.weight_distribution
    table.cycle!
    assert_equal after3.weight_distribution, table.weight_distribution
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
      cycles = 1_000_000_000
      tilty_table = TiltyTable.from_input(input)
      weights = []
      cycle = 0

      until pattern_identified(weights) || cycle > 1500
        30.times do |i|
          tilty_table.cycle!
          weights << tilty_table.weight_distribution
          cycle += 1
        end
        puts "cycle: #{cycle}"
      end
      start = weights.join(';')[0..idx(weights)].split(';').length
      matcher = pattern_identified(weights)
      matched = matcher[:main][1..].split(';').length
      key = ((cycles - start) % matched) + start -1
      puts "#{[start, matched, key, weights[key] ]}"
      return weights[ key ]
    end

    def pattern
      /(?<main>(?<v>;\d+)+?)(\k<main>)+$/
    end

    def idx(weights)
      weights.join(";") =~ pattern
    end

    def pattern_identified(weights)
      pattern.match weights.join(";")
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
    h = rows.length
    w = rows[0].length
    new(rolly: rolly_rocks, unmoving: unmoving_rocks, height: h, width: w)
  end

  def weight_distribution
    rolly.values.inject(0) {|sum, pos| sum + height - pos.y }
  end

  def roll!(dir)
    rolling_now = rolly.values.sort_by {|pos| [-pos.x * dir[0], -pos.y * dir[1]] }
    self.rolly = {}

    rolling_now.each do |rock|
      until impassible?(Position.from_vector(rock + dir))
        rock = rock + dir
      end
      self.rolly[rock.to_a] = Position.from_vector rock
    end
  end

  def impassible? pos
    return true if off_edge?(pos)
    return true unless self.unmoving[pos.to_a].nil?
    return true unless self.rolly[pos.to_a].nil?
    false
  end

  def off_edge? pos
    pos.x < 0 || pos.y < 0 || pos.x > (width - 1) || pos.y > (height - 1)
  end

  def cycle!
    count = rolly.length
    roll!(Map::UP)
    throw StandardError.new("count changed after UP! was: #{count} now: #{rolly.length}") if rolly.length != count
    roll!(Map::LEFT)
    throw StandardError.new("count changed after LEFT! was: #{count} now: #{rolly.length}") if rolly.length != count
    roll!(Map::DOWN)
    throw StandardError.new("count changed after DOWN! was: #{count} now: #{rolly.length}") if rolly.length != count
    roll!(Map::RIGHT)
    throw StandardError.new("count changed after RIGHT! was: #{count} now: #{rolly.length}") if rolly.length != count
  end
end
