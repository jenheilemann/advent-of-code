# --- Day 16: The Floor Will Be Lava ---
# --- Part Two ---

# As you try to work out what might be wrong, the reindeer tugs on your shirt
# and leads you to a nearby control panel. There, a collection of buttons lets
# you align the contraption so that the beam enters from any edge tile and
# heading away from that edge. (You can choose either of two directions for the
# beam if it starts on a corner; for instance, if the beam starts in the
# bottom-right corner, it can start heading either left or upward.)

# So, the beam could start on any tile in the top row (heading downward), any
# tile in the bottom row (heading upward), any tile in the leftmost column
# (heading right), or any tile in the rightmost column (heading left). To
# produce lava, you need to find the configuration that energizes as many tiles
# as possible.

# Find the initial beam configuration that energizes the largest number of
# tiles; how many tiles are energized in that configuration?


require 'set'

EXAMPLE1 = <<~'EXAMPLE'
          .|...\....
          |.-.\.....
          .....|-...
          ........|.
          ..........
          .........\
          ..../.\\..
          .-.-/..|..
          .|....-|.\
          ..//.|....
          EXAMPLE


class TestMain < Minitest::Test
  def test_run
    assert_equal(51, Main.run!(EXAMPLE1))
  end
end

class Main
  class << self
    def run!(input)
      map = Map.from_input(input.strip) {|s| Square.new(contents: s) }
      beams = build_possible_starts(map)
      beams.map {|b| find_number(input, [b]) }.max
    end

    def build_possible_starts(map)
      starts = []
      starts.concat (0..map.row_count-1).map{|y| Beam.new(dir: Map::RIGHT, pos: Position.new(x: 0, y:y)) }
      starts.concat (0..map.row_count-1).map{|y| Beam.new(dir: Map::LEFT, pos: Position.new(x: map.column_count-1, y:y)) }
      starts.concat (0..map.column_count-1).map{|x| Beam.new(dir: Map::UP, pos: Position.new(x:x , y:map.row_count-1)) }
      starts.concat (0..map.column_count-1).map{|x| Beam.new(dir: Map::DOWN, pos: Position.new(x:x , y:0)) }
      starts
    end

    def find_number(input, beams)
      map = Map.from_input(input.strip) {|s| Square.new(contents: s) }
      while beams.length > 0
        beam = beams.shift
        square = map[beam.position]

        while true
          if map.off_edge?(beam.position)
            break
          end
          square = map[beam.position]

          if square.energized_directions.include? beam.direction
            break # allow to disappate, it's in a loop
          end
          square.energize!(beam.direction)

          case
          when beam.move_by?(square)
            beam.position += beam.direction
            next
          when ['\\','/'].include?(square.contents)
            beam.direction = beam.turn(square.contents)
            beam.position += beam.direction
            next
          when ['|', '-'].include?(square.contents)
            beams += beam.split!
            break
          else
            throw StandardError.new("Never gets here")
          end
        end
      end

      map.each.sum(0) {|s| s.energized ? 1 : 0 }
    end
  end
end

class Beam
  attr_accessor :direction, :position
  def initialize(dir:, pos:)
    @direction = dir
    @position = pos
  end

  def split!
    one = self.class.new(dir: direction, pos: position)
    one.turn('/')
    one.position += one.direction
    two = self.class.new(dir: direction, pos: position)
    two.turn('\\')
    two.position += two.direction
    [one, two]
  end

  def turn(mirror)
    keys = {
      '/' => {
        Map::UP => Map::RIGHT,
        Map::DOWN => Map::LEFT,
        Map::RIGHT => Map::UP,
        Map::LEFT => Map::DOWN,
      },
      '\\' => {
        Map::UP => Map::LEFT,
        Map::DOWN => Map::RIGHT,
        Map::RIGHT => Map::DOWN,
        Map::LEFT => Map::UP,
      }
    }
    @direction = keys[mirror][@direction]
  end

  def move_by?(square)
    return true if square.contents == '.'
    return true if [Map::UP, Map::DOWN].include?(direction) && square.contents == '|'
    return true if [Map::LEFT, Map::RIGHT].include?(direction) && square.contents == '-'
    false
  end

  def split?(square)
    return true if [Map::UP, Map::DOWN].include? direction && square.contents == '-'
    return true if [Map::LEFT, Map::RIGHT].include? direction && square.contents == '|'
    false
  end
end

class Square
  attr_reader :energized, :contents, :energized_directions
  def initialize(contents: '.')
    @contents = contents
    @energized = false
    @energized_directions = Set.new
  end

  def to_s
    contents
  end

  def energize!(direction)
    @energized = true
    @energized_directions << direction
  end
end

