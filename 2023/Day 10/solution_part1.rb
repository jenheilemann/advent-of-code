# --- Day 10: Pipe Maze ---

# Scanning the area, you discover that the entire field you're standing on is
# densely packed with pipes; it was hard to tell at first because they're the
# same metallic silver color as the "ground". You make a quick sketch of all of
# the surface pipes you can see (your puzzle input).

# The pipes are arranged in a two-dimensional grid of tiles:

    # | is a vertical pipe connecting north and south.
    # - is a horizontal pipe connecting east and west.
    # L is a 90-degree bend connecting north and east.
    # J is a 90-degree bend connecting north and west.
    # 7 is a 90-degree bend connecting south and west.
    # F is a 90-degree bend connecting south and east.
    # . is ground; there is no pipe in this tile.
    # S is the starting position of the animal; there is a pipe on this tile,
    #   but your sketch doesn't show what shape the pipe has.

# Based on the acoustics of the animal's scurrying, you're confident the pipe
# that contains the animal is one large, continuous loop.

# The S tile is still a 90-degree F bend: you can tell because of how the
# adjacent pipes connect to it.

# Unfortunately, there are also many pipes that aren't connected to the loop!

# You can still figure out which pipes form the main loop: they're the ones
# connected to S, pipes those pipes connect to, pipes those pipes connect to,
# and so on. Every pipe in the main loop connects to its two neighbors
# (including S, which will have exactly two pipes connecting to it, and which is
# assumed to connect back to those two pipes).

# If you want to get out ahead of the animal, you should find the tile in the
# loop that is farthest from the starting position. Because the animal is in the
# pipe, it doesn't make sense to measure this by direct distance. Instead, you
# need to find the tile that would take the longest number of steps along the
# loop to reach from the starting point - regardless of which way around the
# loop the animal went.

# Find the single giant loop starting at S. How many steps along the loop does
# it take to get from the starting position to the point farthest from the
# starting position?

require 'matrix'

EXAMPLE1 =
".....
.S-7.
.|.|.
.L-J.
....."

EXAMPLE2 =
"7-F7-
.FJ|7
SJLL7
|F--J
LJ.LJ"

class TestMain < Minitest::Test
  def test_run
    assert_equal(4, Main.run!(EXAMPLE1))
    assert_equal(8, Main.run!(EXAMPLE2))
  end
end

class TestMap < Minitest::Test
  def test_find_start
    map = Map.from_input(EXAMPLE1)
    assert map.find_start.is_start?
    assert_equal Vector[1,1], map.find_start.location
    map = Map.from_input(EXAMPLE2)
    assert map.find_start.is_start?
    assert_equal Vector[0,2], map.find_start.location
  end

  def test_valid_connections
    map = Map.from_input(EXAMPLE1)
    assert_equal [Vector[1,2], Vector[2,1]], map.valid_connections(map.find_start)
    map = Map.from_input(EXAMPLE2)
    assert_equal [Vector[0,3], Vector[1,2]], map.valid_connections(map.find_start)
  end
end

class Main
  class << self
    def run!(input)
      map = Map.from_input(input)
      start = map.find_start
      path = find_path(start, map)
      path.length/2
    end

    def find_path(start, map)
      this_step = map[map.valid_connections(start).first]
      path = [start.location, this_step.location]
      previous = start.location

      until this_step.is_start?
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

  def [](vec)
    @map[vec] || Ground.new(vec)
  end

  def valid_connections(thing)
    thing.connectable.filter {|d|
      !@map[thing.location + d].nil? &&
      @map[thing.location + d].connectable.any? {|dir| Connectable[dir] == d }
    }.map{|d| thing.location + d}
  end
end

Ground = Struct.new(:location) do
  def self.by_type(vec, str)
    ground_type = {
      "S" => Start,
      "|" => PipeUpDown,
      "-" => PipeLeftRight,
      "L" => PipeUpRight,
      "J" => PipeUpLeft,
      "F" => PipeDownRight,
      "7" => PipeDownLeft,
      "." => Ground,
    }
   ground_type[str].new(vec)
  end
  def connectable; []; end
  def is_start?; false; end
  def connections
    connectable.map {|v| v + location }
  end
end

class Start < Ground
  def connectable; [Map::UP, Map::DOWN, Map::LEFT, Map::RIGHT]; end
  def is_start?; true; end
end
class PipeUpDown < Ground
  def connectable; [Map::UP, Map::DOWN]; end
end
class PipeLeftRight < Ground
  def connectable; [Map::LEFT, Map::RIGHT]; end
end
class PipeUpRight < Ground
  def connectable; [Map::UP, Map::RIGHT]; end
end
class PipeUpLeft < Ground
  def connectable; [Map::UP, Map::LEFT]; end
end
class PipeDownRight < Ground
  def connectable; [Map::DOWN, Map::RIGHT]; end
end
class PipeDownLeft < Ground
  def connectable; [Map::DOWN, Map::LEFT]; end
end
