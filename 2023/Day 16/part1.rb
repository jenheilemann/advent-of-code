# --- Day 16: The Floor Will Be Lava ---

# The contraption is aligned so that most of the beam bounces around the grid, but
# each tile on the grid converts some of the beam's light into heat to melt the
# rock in the cavern.

# You note the layout of the contraption (your puzzle input).

# The beam enters in the top-left corner from the left and heading to the right.
# Then, its behavior depends on what it encounters as it moves:

#     If the beam encounters empty space (.), it continues in the same direction.

#     If the beam encounters a mirror (/ or \), the beam is reflected 90 degrees
#       depending on the angle of the mirror. For instance, a rightward-moving
#       beam that encounters a / mirror would continue upward in the mirror's
#       column, while a rightward-moving beam that encounters a \ mirror would
#       continue downward from the mirror's column.

#     If the beam encounters the pointy end of a splitter (| or -), the beam
#       passes through the splitter as if the splitter were empty space. For
#       instance, a rightward-moving beam that encounters a - splitter would
#       continue in the same direction.

#     If the beam encounters the flat side of a splitter (| or -), the beam is
#       split into two beams going in each of the two directions the splitter's
#       pointy ends are pointing. For instance, a rightward-moving beam that
#       encounters a | splitter would split into two beams: one that continues
#       upward from the splitter's column and one that continues downward from
#       the splitter's column.

# Beams do not interact with other beams; a tile can have many beams passing
# through it at the same time. A tile is energized if that tile has at least one
# beam pass through it, reflect in it, or split in it.

# The light isn't energizing enough tiles to produce lava; to debug the
# contraption, you need to start by analyzing the current situation. With the
# beam starting in the top-left heading right, how many tiles end up being
# energized?

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
    assert_equal(46, Main.run!(EXAMPLE1))
  end
end

class Main
  class << self
    def run!(input)
      map = Map.from_input(input.strip) {|s| Square.new(contents: s) }
      beams = [Beam.new(dir: Map::RIGHT, pos: Position.new(x: 0, y:0))]

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

