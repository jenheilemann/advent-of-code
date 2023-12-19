# --- Day 18: Lavaduct Lagoon  ---
# --- Part Two ---

# Each hexadecimal code is six hexadecimal digits long. The first five
# hexadecimal digits encode the distance in meters as a five-digit hexadecimal
# number. The last hexadecimal digit encodes the direction to dig: 0 means R, 1
# means D, 2 means L, and 3 means U.

# Convert the hexadecimal color codes into the correct instructions; if the
# Elves follow this new dig plan, how many cubic meters of lava could the lagoon
# hold?


EXAMPLE1 = <<~'EXAMPLE'
          R 6 (#70c710)
          D 5 (#0dc571)
          L 2 (#5713f0)
          D 2 (#d2c081)
          R 2 (#59c680)
          D 2 (#411b91)
          L 5 (#8ceee2)
          U 2 (#caa173)
          L 1 (#1b58a2)
          U 2 (#caa171)
          R 2 (#7807d2)
          U 3 (#a77fa3)
          L 2 (#015232)
          U 2 (#7a21e3)
          EXAMPLE


class TestMain < Minitest::Test
  def test_run
    assert_equal(952408144115, Main.run!(EXAMPLE1))
  end
end

class Main
  DIRS = { 1 => [0,1], 0 => [1,0], 3 => [0,-1], 2 => [-1,0] }

  class << self
    def run!(input)
      commands = input.strip.split("\n").map do |s|
        c = s.split(" ")
        [c.last[-2..-2].to_i, c.last[2..-3].to_i(16)]
      end
      points = to_vertices(commands)

      # shoelace theorem & pick's theorem
      area = 0
      circumference = 0

      points.each_cons(2) do |(x1, y1), (x2, y2)|
        area +=(x1 * y2) - (y1*x2)
        circumference += (x1 - x2).abs + (y1 - y2).abs
      end

      (area/2).abs + circumference/2 + 1
    end

    def to_vertices(commands)
      vertices = [[0,0]]
      commands.each do |dir, dist|
        x = vertices.last[0]
        y = vertices.last[1]
        xx = x + DIRS[dir][0] * dist
        yy = y + DIRS[dir][1] * dist
        vertices << [xx, yy]
      end
      vertices
    end
  end
end
