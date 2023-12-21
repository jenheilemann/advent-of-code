# --- Day 21: Step Counter ---

# While you wait, one of the Elves that works with the gardener heard how good you are at solving problems and would like your help. He needs to get his steps in for the day, and so he'd like to know which garden plots he can reach with exactly his remaining 64 steps.

# He gives you an up-to-date map (your puzzle input) of his starting position (S), garden plots (.), and rocks (#).

# The Elf starts at the starting position (S) which also counts as a garden plot. Then, he can take one step north, south, east, or west, but only onto tiles that are garden plots.

# Starting from the garden plot marked S on your map, how many garden plots could the Elf reach in exactly 64 steps?

require 'set'

EXAMPLE1 = <<~'EXAMPLE'
          ...........
          .....###.#.
          .###.##..#.
          ..#.#...#..
          ....#.#....
          .##..S####.
          .##..#...#.
          .......##..
          .##.#.####.
          .##..##.##.
          ...........
          EXAMPLE


class TestMain < Minitest::Test
  def test_run
    assert_equal(16, Main.run!(EXAMPLE1, 6))
    assert_equal(39, Main.run!(EXAMPLE1, 64))
  end
end

class Main
  class << self
    def run!(input, steps = 64)
      map = Map.from_input input.strip
      locations = Set.new()
      old_locations = nil
      locations << Vector[*map.index("S")]
      dirs = [Map::UP, Map::DOWN, Map::LEFT, Map::RIGHT]

      steps.times do |n|
        new_locations = Set.new
        locations.each do |loc|
          dirs.each do |dir|
            next unless map.passible?(loc + dir)
            new_locations << loc + dir
          end
        end
        if old_locations == new_locations && n.even?
          # cycle identified
          return old_locations.length
        end
        old_locations = locations
        locations = new_locations
      end

      locations.length
    end
  end
end

class TestMap < Minitest::Test
  def test_passible
    map = Map.from_input(EXAMPLE1)
    assert map.passible? [1,1]
    assert map.passible? [5,5]
    assert map.passible? [2,1]

    refute map.passible? [-1,0]
    refute map.passible? [0,11]
    refute map.passible? [1,2]
  end
end

class Map
  def passible?(vec)
    return false if outside_bounds? vec
    return false if self[*vec] == '#'
    true
  end
end
