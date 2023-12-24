# --- Day 23: A Long Walk ---

# There's a map of nearby hiking trails (your puzzle input) that indicates paths
# (.), forest (#), and steep slopes (^, >, v, and <).

# You're currently on the single path tile in the top row; your goal is to reach
# the single path tile in the bottom row. Because of all the mist from the
# waterfall, the slopes are probably quite icy; if you step onto a slope tile,
# your next step must be downhill (in the direction the arrow is pointing). To
# make sure you have the most scenic hike possible, never step onto the same
# tile twice. What is the longest hike you can take?

# Find the longest hike you can take through the hiking trails listed on your
# map. How many steps long is the longest hike?


EXAMPLE1 = <<~'EXAMPLE'
#.#####################
#.......#########...###
#######.#########.#.###
###.....#.>.>.###.#.###
###v#####.#v#.###.#.###
###.>...#.#.#.....#...#
###v###.#.#.#########.#
###...#.#.#.......#...#
#####.#.#.#######.#.###
#.....#.#.#.......#...#
#.#####.#.#.#########v#
#.#...#...#...###...>.#
#.#.#v#######v###.###v#
#...#.>.#...>.>.#.###.#
#####v#.#.###v#.#.###.#
#.....#...#...#.#.#...#
#.#########.###.#.#.###
#...###...#...#...#.###
###.###.#.###v#####v###
#...#...#.#.>.>.#.>.###
#.###.###.#.###.#.#v###
#.....###...###...#...#
#####################.#
          EXAMPLE


class TestMain < Minitest::Test
  def test_run
    assert_equal(94, Main.run!(EXAMPLE1))
  end
end

class Main
  class << self
    def run!(input)
      map = Map.from_input(input)

      start = Vector[1,0]
      finish = Vector[map.width-2, map.height-1]
      paths = [[start]]
      successful = []
      puts "start: #{start} finish: #{finish}"

      until paths.empty?
        path = paths.shift
        if path.last == finish
          successful << path
          puts "Successes: #{successful.length}"
          next
        end

        Map::DIRECTIONS.each do |dir|
          step = path.last + dir
          if map.passible?(step, dir) && !path[..-2].include?(step)
            new_path = path.dup << step
            paths << new_path
          end
        end
      end

      successful.map(&:length).max - 1
    end
  end
end


class TestMap < Minitest::Test
  def test_passible
    map = Map.from_input(EXAMPLE1)
    assert map.passible? [1,0], Map::UP
    refute map.passible? [0,1], Map::UP
    refute map.passible? [3,4], Map::UP
    assert map.passible? [3,4], Map::DOWN
    refute map.passible? [10,3], Map::LEFT
    assert map.passible? [10,3], Map::RIGHT
  end
end


class Map
  SLOPES = {
    UP    => '^',
    DOWN  => 'v',
    LEFT  => '<',
    RIGHT => '>',
  }

  def passible?(loc, dir)
    return false if outside_bounds?(loc)
    return false if self[*loc] == '#'
    return true if self[*loc] == '.'
    return true if SLOPES[dir] == self[*loc]
    false
  end
end
