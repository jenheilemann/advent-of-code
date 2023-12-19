# --- Day 10: Pipe Maze ---
# --- Part Two ---

# You quickly reach the farthest point of the loop, but the animal never
# emerges. Maybe its nest is within the area enclosed by the loop?

# Figure out whether you have time to search for the nest by calculating the
# area within the loop. How many tiles are enclosed by the loop?

require 'matrix'
require 'set'

EXAMPLE1 =
".....
.S-7.
.|.|.
.L-J.
....."

EXAMPLE2 =
"..........
.S------7.
.|F----7|.
.||....||.
.||....||.
.|L-7F-J|.
.|..||..|.
.L--JL--J.
.........."

EXAMPLE3 =
"FF7FSF7F7F7F7F7F---7
L|LJ||||||||||||F--J
FL-7LJLJ||||||LJL-77
F--JF--7||LJLJ7F7FJ-
L---JF-JLJ.||-FJLJJ7
|F|F-JF---7F7-L7L|7|
|FFJF7L7F-JF7|JL---7
7-L-JL7||F7|L7F-7F7|
L.L7LFJ|||||FJL7||LJ
L7JLJL-JLJLJL--JLJ.L"

class TestMain < Minitest::Test
  def test_run
    assert_equal(1, Main.run!(EXAMPLE1))
    assert_equal(4, Main.run!(EXAMPLE2))
    assert_equal(10, Main.run!(EXAMPLE3))
  end
end

class TestMap < Minitest::Test
  def test_find_start
    map = Map.from_input(EXAMPLE1)
    assert map.find_start.is_start?
    assert_equal Vector[1,1], map.find_start.location
  end

  def test_valid_connections
    map = Map.from_input(EXAMPLE1)
    assert_equal [Vector[1,2], Vector[2,1]], map.valid_connections(map.find_start)
  end
end

class Main
  class << self
    def run!(input)
      map = Map.from_input(input)
      start = map.find_start
      path = find_path(start, map)

      inside(map, path)
    end

    def inside(map, path)
      inside = 0
      crossings = 0
      map.locations.each do |loc, obj|
        crossings = 0 if loc[0] == 0
        crossings += 1 if obj.is_path? && obj.important?
        inside += 1 if (crossings % 2 == 1) && !obj.is_path?
      end
      inside
    end

    def find_path(start, map)
      start.sidedness = :path
      this_step = map[map.valid_connections(start).first]
      path = Set[start.location, this_step.location]
      previous = start.location

      until this_step.is_start?
        this_step.sidedness = :path
        new_step = this_step.connections.find {|v| v != previous  }
        path << new_step
        previous = this_step.location
        this_step = map[new_step]
      end
      path
    end
  end
end

class Map
  UP    = ::Vector[ 0, -1 ]
  DOWN  = ::Vector[ 0,  1 ]
  LEFT  = ::Vector[-1,  0 ]
  RIGHT = ::Vector[ 1,  0 ]
  Connectable = {
    Map::UP => Map::DOWN,
    Map::DOWN => Map::UP,
    Map::LEFT => Map::RIGHT,
    Map::RIGHT => Map::LEFT,
  }

  class << self
    def from_input(input)
      rows = input.split("\n")
      map = {}
      rows.each_with_index do |row, y|
        row.chars.each_with_index do |type,x|
          map[Vector[x, y]] = Ground.by_type(Vector[x, y], type)
        end
      end
      self.new(map, input, rows.length, rows.first.length)
    end
  end

  def initialize(locations, input_str, height, width)
    @map = locations
    @input = input_str.split("\n")
    @height = height
    @width = width
  end

  def find_start
    start_str = "S"
    start_y = @input.index{|s| s.match start_str }
    start_x = @input[start_y].index( start_str )
    @map[Vector[start_x, start_y]]
  end

  def locations
    @map
  end

  def [](vec)
    @map[vec]
  end

  def valid_connections(thing)
    thing.class.connectable.filter {|d|
      !@map[thing.location + d].nil? &&
      @map[thing.location + d].class.connectable.any? {|dir| Connectable[dir] == d }
    }.map{|d| thing.location + d}
  end
end

Ground = Struct.new(:location, :sidedness) do
  class << self
    def types
      {
        "S" => Start,
        "|" => PipeUpDown,
        "-" => PipeLeftRight,
        "L" => PipeUpRight,
        "J" => PipeUpLeft,
        "F" => PipeDownRight,
        "7" => PipeDownLeft,
        "." => Ground,
      }
    end
    def by_type(vec, str)
      types[str].new(vec, :unknown)
    end
    def connectable; []; end
  end
  def is_path?
    sidedness == :path
  end
  def important?; false; end
  def is_start?; false; end
  def connections
    self.class.connectable.map {|v| v + location }
  end
end

class Start < Ground
  def self.connectable; [Map::UP, Map::DOWN, Map::LEFT, Map::RIGHT]; end
  def is_start?; true; end
end
class PipeUpDown < Ground
  def self.connectable; [Map::UP, Map::DOWN]; end
  def important?; true; end
end
class PipeLeftRight < Ground
  def self.connectable; [Map::LEFT, Map::RIGHT]; end
end
class PipeUpRight < Ground
  def self.connectable; [Map::UP, Map::RIGHT]; end
  def important?; true; end
end
class PipeUpLeft < Ground
  def self.connectable; [Map::UP, Map::LEFT]; end
  def important?; true; end
end
class PipeDownRight < Ground
  def self.connectable; [Map::DOWN, Map::RIGHT]; end
end
class PipeDownLeft < Ground
  def self.connectable; [Map::DOWN, Map::LEFT]; end
end
