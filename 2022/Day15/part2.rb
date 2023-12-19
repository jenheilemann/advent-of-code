# --- Day 15: Beacon Exclusion Zone ---
# --- Part Two ---

# Your handheld device indicates that the distress signal is coming from a
# beacon nearby. The distress beacon is not detected by any sensor, but the
# distress beacon must have x and y coordinates each no lower than 0 and no
# larger than 4000000.

# To isolate the distress beacon's signal, you need to determine its tuning
# frequency, which can be found by multiplying its x coordinate by 4000000 and
# then adding its y coordinate.

# Find the only possible position for the distress beacon. What is its tuning
# frequency?

require 'memoist'
require 'set'
require 'forwardable'

EXAMPLE = "Sensor at x=2, y=18: closest beacon is at x=-2, y=15
Sensor at x=9, y=16: closest beacon is at x=10, y=16
Sensor at x=13, y=2: closest beacon is at x=15, y=3
Sensor at x=12, y=14: closest beacon is at x=10, y=16
Sensor at x=10, y=20: closest beacon is at x=10, y=16
Sensor at x=14, y=17: closest beacon is at x=10, y=16
Sensor at x=8, y=7: closest beacon is at x=2, y=10
Sensor at x=2, y=0: closest beacon is at x=2, y=10
Sensor at x=0, y=11: closest beacon is at x=2, y=10
Sensor at x=20, y=14: closest beacon is at x=25, y=17
Sensor at x=17, y=20: closest beacon is at x=21, y=22
Sensor at x=16, y=7: closest beacon is at x=15, y=3
Sensor at x=14, y=3: closest beacon is at x=15, y=3
Sensor at x=20, y=1: closest beacon is at x=15, y=3"

class TestMain < Minitest::Test
  def test_run
    assert_equal(56000011, Main.run!(EXAMPLE, max: 20))
  end
end

class TestSensor < Minitest::Test
  def test_from_input
    str = 'Sensor at x=0, y=11: closest beacon is at x=2, y=10'
    sensor = Sensor.from_input(str)
    assert_kind_of Sensor, sensor
    assert_equal Position.new(x: 0, y: 11), sensor.location
    assert_equal Position.new(x: 2, y: 10), sensor.beacon
  end

  def test_range
    str = 'Sensor at x=8, y=7: closest beacon is at x=2, y=10'
    sensor = Sensor.from_input(str)
    assert_equal 9, sensor.range

    sensor = Sensor.new(location: Position.new(x: 3, y: 3), beacon: Position.new(x: 3, y: 10))
    assert_equal 7, sensor.range
  end

  def test_cells_in_range
    str = 'Sensor at x=8, y=7: closest beacon is at x=2, y=10'
    sensor = Sensor.from_input(str)
    assert_equal 2..14, sensor.cells_in_range(4)
    assert_equal 1..15, sensor.cells_in_range(5)
    assert_equal 0..16, sensor.cells_in_range(6)
    assert_nil sensor.cells_in_range(-40)
    assert_nil sensor.cells_in_range(40)

    str = 'Sensor at x=2, y=0: closest beacon is at x=2, y=10'
    sensor = Sensor.from_input(str)
    assert_equal 10, sensor.range
    assert_equal -4..8, sensor.cells_in_range(4)
    assert_equal -3..7, sensor.cells_in_range(5)
    assert_equal -2..6, sensor.cells_in_range(6)
    assert_nil sensor.cells_in_range(-40)
    assert_nil sensor.cells_in_range(40)

    sensor = Sensor.new(location: Position.new(x: 3, y: 3), beacon: Position.new(x: 3, y: 10))
    assert_equal -2..8, sensor.cells_in_range(1)
    assert_equal -3..9, sensor.cells_in_range(2)
    assert_equal -4..10, sensor.cells_in_range(3)
    assert_equal -1..7, sensor.cells_in_range(6)
    assert_nil sensor.cells_in_range(-40)
    assert_nil sensor.cells_in_range(40)
  end
end

class Main
  class << self
    def run!(input, max: 4000000)
      intersections = Set.new
      sensors = input.split("\n").map {|s| Sensor.from_input(s) }
      sensors.permutation(2) do |(s1, s2)|
        intersections += s1.intersect(s2)
      end
      in_range = intersections
        .filter{|pos| pos.x >= 0 && pos.x <= max && pos.y >= 0 && pos.y <= max }
        .filter {|pos| sensors.all?{|s| s.distance_to(pos) > s.range } }
      in_range[0].x * 4_000_000 + in_range[0].y
    end
  end
end

Sensor = Struct.new(:location, :beacon, keyword_init: true) do
  extend Memoist
  extend Forwardable
  def_delegators :location, :x, :y
  def_delegator :location, :taxicab_distance_to, :distance_to

  def self.from_input(str)
    loc, bcn = str.split(":")
    location = Position.from_input(loc)
    beacon = Position.from_input(bcn)
    new(location: location, beacon: beacon)
  end

  def intersect(other)
    [
      {x1: x - range+1, x2: other.x - other.range+1 },
      {x1: x - range+1, x2: other.x + other.range+1 },
      {x1: x + range+1, x2: other.x + other.range+1 },
      {x1: x + range+1, x2: other.x - other.range+1 },
    ].map {|v| Position.new(x: (v[:x2] + other.y + v[:x1] - y)/2, y: (v[:x2] + other.y - v[:x1] + y)/2) }
  end

  def range
    distance_to(beacon)
  end

  def cells_in_range(row)
    row_range = range - (y - row).abs
    return nil if row_range < 0
    (x - row_range)..(x+row_range)
  end
  memoize :cells_in_range, :range, :distance_to
end
