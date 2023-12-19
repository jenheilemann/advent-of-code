# --- Day 18: Lavaduct Lagoon  ---

# The digger starts in a 1 meter cube hole in the ground. They then dig the
# specified number of meters up (U), down (D), left (L), or right (R), clearing
# full 1 meter cubes as they go. The directions are given as seen from above, so
# if "up" were north, then "right" would be east, and so on. Each trench is also
# listed with the color that the edge of the trench should be painted as an RGB
# hexadecimal color code. This is just the edge of the lagoon; the next step is
# to dig out the interior so that it is one meter deep as well.

# The Elves are concerned the lagoon won't be large enough; if they follow their
# dig plan, how many cubic meters of lava could it hold?

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
    assert_equal(62, Main.run!(EXAMPLE1))
  end
end

class Main
  DIRS = { 'D':[0,1], 'R':[1,0], 'U':[0,-1], 'L':[-1,0] }

  class << self
    def run!(input)
      commands = input.strip.split("\n").map do |s|
        c = s.split(" ")
        [c[0].to_sym, c[1].to_i]
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
