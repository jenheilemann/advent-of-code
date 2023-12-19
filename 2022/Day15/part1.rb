# --- Day 15: Beacon Exclusion Zone ---

# The sensors aren't very powerful, but that's okay; your handheld device
# indicates that you're close enough to the source of the distress signal to use
# them. You pull the emergency sensor system out of your pack, hit the big
# button on top, and the sensors zoom off down the tunnels.

# Once a sensor finds a spot it thinks will give it a good reading, it attaches
# itself to a hard surface and begins monitoring for the nearest signal source
# beacon. Sensors and beacons always exist at integer coordinates. Each sensor
# knows its own position and can determine the position of a beacon precisely;
# however, sensors can only lock on to the one beacon closest to the sensor as
# measured by the Manhattan distance. (There is never a tie where two beacons
# are the same distance to a sensor.)

# It doesn't take long for the sensors to report back their positions and
# closest beacons (your puzzle input).

# This isn't necessarily a comprehensive map of all beacons in the area, though.
# Because each sensor only identifies its closest beacon, if a sensor detects a
# beacon, you know there are no other beacons that close or closer to that
# sensor. There could still be beacons that just happen to not be the closest
# beacon to any sensor.

# None of the detected beacons seem to be producing the distress signal, so
# you'll need to work out where the distress beacon is by working out where it
# isn't. For now, keep things simple by counting the positions where a beacon
# cannot possibly be along just a single row.

# Consult the report from the sensors you just deployed. In the row where
# y=2000000, how many positions cannot contain a beacon?

require 'memoist'
require 'set'

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
    assert_equal(26, Main.run!(EXAMPLE, y: 10))
  end
end

class TestPosition < Minitest::Test
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
    def run!(input, y: 2000000)
      set = Set.new
      beacons = Set.new
      input.split("\n").map do |s|
        sensor = Sensor.from_input(s)
        in_range = sensor.cells_in_range(y)
        puts s
        puts "in_range: #{in_range}"
        set += in_range unless in_range.nil?
        beacons.add(sensor.beacon.x) if sensor.beacon.y == y
      end
      puts "set: #{set.length}"
      puts "beacons: #{beacons}"
      set.length - beacons.length
    end
  end
end

Sensor = Struct.new(:location, :beacon, keyword_init: true) do
  extend Memoist

  def self.from_input(str)
    loc, bcn = str.split(":")
    location = Position.from_input(loc)
    beacon = Position.from_input(bcn)
    new(location: location, beacon: beacon)
  end

  def range
    r = location - beacon
    r[0].abs + r[1].abs
  end

  def cells_in_range(row)
    row_range = range - (location.y - row).abs
    return nil if row_range < 0
    (location.x - row_range)..(location.x+row_range)
  end
  memoize :cells_in_range
end

class Position
end
