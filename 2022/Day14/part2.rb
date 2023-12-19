# --- Day 14: Regolith Reservoir ---
# --- Part Two ---

# You realize you misread the scan. There isn't an endless void at the bottom of
# the scan - there's floor, and you're standing on it!

# You don't have time to scan the floor, so assume the floor is an infinite
# horizontal line with a y coordinate equal to two plus the highest y coordinate
# of any point in your scan.

# In the example above, the highest y coordinate of any point is 9, and so the
# floor is at y=11. (This is as if your scan contained one extra rock path like
# -infinity,11 -> infinity,11.) With the added floor, the example now looks like
# this:

#         ...........+........
#         ....................
#         ....................
#         ....................
#         .........#...##.....
#         .........#...#......
#         .......###...#......
#         .............#......
#         .............#......
#         .....#########......
#         ....................
# <-- etc #################### etc -->

# To find somewhere safe to stand, you'll need to simulate falling sand until a
# unit of sand comes to rest at 500,0, blocking the source entirely and stopping
# the flow of sand into the cave.

# Using your scan, simulate the falling sand until the source of the sand
# becomes blocked. How many units of sand come to rest?


require 'set'

EXAMPLE = "498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9"
EXAMPLE_START_MAP =
"......+...
..........
..........
..........
....#...##
....#...#.
..###...#.
........#.
........#.
#########."
EXAMPLE_END_MAP =
"......+...
..........
......o...
.....ooo..
....#ooo##
...o#ooo#.
..###ooo#.
....oooo#.
.o.ooooo#.
#########."

AIR = "."
SAND = "o"
ROCK = "#"
SOURCE = "+"


class TestMain < Minitest::Test
  def test_run
    assert_equal(93, Main.run!(EXAMPLE))
  end
end

class TestPostition < Minitest::Test
  def test_from_input
    position = Position.from_input("498,4")
    assert_equal(498, position.x)
    assert_equal(4, position.y)
  end

  def test_down
    position = Position.from_input("498,4")
    down = position.down
    refute_same(position, down)
    assert_equal(498, down.x)
    assert_equal(5, down.y)
  end

  def test_down_left
    position = Position.from_input("498,4")
    down_left = position.down_left
    refute_same(position, down_left)
    assert_equal(497, down_left.x)
    assert_equal(5, down_left.y)
  end

  def test_down_right
    position = Position.from_input("498,4")
    down_right = position.down_right
    refute_same(position, down_right)
    assert_equal(499, down_right.x)
    assert_equal(5, down_right.y)
  end

  def test_range_to_x
    pos1 =  Position.new(x: 1, y: 5)
    pos1a = Position.new(x: 1, y: 5)
    pos2 =  Position.new(x: 6, y: 8)
    assert_equal(1..6, pos1.range_to_x(pos2))
    assert_equal(1..1, pos1.range_to_x(pos1a))
    assert_equal(1..6, pos2.range_to_x(pos1))
  end

  def test_range_to_y
    pos1 =  Position.new(x: 1, y: 5)
    pos1a = Position.new(x: 1, y: 5)
    pos2 =  Position.new(x: 6, y: 8)
    assert_equal(5..8, pos1.range_to_y(pos2))
    assert_equal(5..5, pos1.range_to_y(pos1a))
    assert_equal(5..8, pos2.range_to_y(pos1))
  end

  def test_all_positions_inclusive
    pos1 =  Position.new(x: 1, y: 5)
    pos2 =  Position.new(x: 5, y: 5)
    res = [[1,5], [2,5], [3,5], [4,5], [5,5]].map{|(x,y)| Position.new(x: x, y: y) }
    assert_equal res, pos1.all_positions_inclusive(pos2)

    pos1 =  Position.new(x: 5, y: 5)
    pos2 =  Position.new(x: 5, y: 1)
    res = [[5,1], [5,2], [5,3], [5,4], [5,5]].map{|(x,y)| Position.new(x: x, y: y) }
    assert_equal res, pos1.all_positions_inclusive(pos2)
  end
end

class TestCave < Minitest::Test
  def test_from_input
    cave = Cave.from_input(EXAMPLE)
    assert_kind_of Cave, cave
    assert_equal cave.map[[498, 4]], Position.new(x: 498, y: 4)
    assert_equal cave.map[[498, 5]], Position.new(x: 498, y: 5)
  end

  def test_new_sets_max_and_mins
    cave = Cave.from_input(EXAMPLE)
    assert_equal 9, cave.max_y
    assert_equal 503, cave.max_x
    assert_equal 494, cave.min_x
  end

  def test_passible
    cave = Cave.from_input(EXAMPLE)
    refute cave.passible?(Position.new(x: 500, y: 9))
    refute cave.passible?(Position.new(x: 498, y: 4))
    assert cave.passible?(Position.new(x: 497, y: 4))
    assert cave.passible?(Position.new(x: 500, y: 8))
  end

  def test_off_edge
    cave = Cave.from_input(EXAMPLE)
    refute cave.off_edge?(Position.new(x: 500, y: 9))
    refute cave.off_edge?(Position.new(x: 498, y: 4))
    assert cave.off_edge?(Position.new(x: 504, y: 4))
    assert cave.off_edge?(Position.new(x: 500, y: 10))
  end
end

class Main
  class << self
    def run!(input)
      cave = Cave.from_input(input)
      cave.add_sand!
    end
  end
end

Position = Struct.new(:x, :y, keyword_init: true) do
  class << self
    def from_input(str)
      x, y = *str.split(",").map(&:to_i)
      new(x: x, y: y)
    end
  end

  def down; Position.new(x: x, y: y+1); end
  def down_left; Position.new(x: x-1, y: y+1); end
  def down_right; Position.new(x: x+1, y: y+1); end
  def to_vector; Vector[x, y]; end
  def to_a; [x, y]; end

  def range_to_x(other)
    [x, other.x].min..[x, other.x].max
  end

  def range_to_y(other)
    [y, other.y].min..[y, other.y].max
  end

  def all_positions_inclusive(other)
    x_range = range_to_x(other)
    return x_range.map{|new_x| Position.new(x: new_x, y: y) } if x_range.size > 1
    range_to_y(other).map{|new_y| Position.new(x: x, y: new_y)}
  end
end

Cave = Struct.new(:map, :sand, keyword_init: true) do
  class << self
    def from_input(str)
      rock_shapes = str.split("\n")
      positions = Set.new
      rock_shapes.each do |str|
        str.split(" -> ").each_cons(2) do |a, b|
          positions.merge Position.from_input(a).all_positions_inclusive(Position.from_input(b))
        end
      end
      map = positions.to_a.to_h { |position| [position.to_a, position]}

      new(map: map)
    end
  end

  attr_reader :min_x, :max_x,:max_y, :sand
  def initialize(*args)
    super
    x_values = map.map {|ar, pos| pos.x }
    @min_x = x_values.min
    @max_x = x_values.max
    @max_y = map.map{|ar, pos| pos.y }.max
    @sand = {}

    add_floor
  end

  def add_floor
    a = Position.new(x: (min_x - max_y - 5), y: max_y+2)
    b = Position.new(x: (max_x + max_y + 5), y: max_y+2)
    floor = a.all_positions_inclusive(b)
    floor.each{|pos| map[pos.to_a] = pos }
  end

  def add_sand!
    current = Position.new(x: 500, y: 0)
    steps = []
    while sand[[500,0]].nil?
      go_to = [current.down, current.down_left, current.down_right].find{|pos| passible?(pos)}
      unless go_to.nil?
        steps << current
        current = go_to
      else
        @sand[current.to_a] = current
        current = steps.pop
      end
    end
    sand.length
  end

  def passible?(position)
    map[position.to_a].nil? && sand[position.to_a].nil?
  end

  def off_edge?(position)
    return true if position.x > max_x
    return true if position.x < min_x
    return true if position.y > max_y
    false
  end
end
