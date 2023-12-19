# --- Day 13: Point of Incidence ---

# As you move through the valley of mirrors, you find that several of them have
# fallen from the large metal frames keeping them in place. The mirrors are
# extremely flat and shiny, and many of the fallen mirrors have lodged into the
# ash at strange angles. Because the terrain is all one color, it's hard to tell
# where it's safe to walk or where you're about to run into a mirror.

# You note down the patterns of ash (.) and rocks (#) that you see as you walk
# (your puzzle input); perhaps by carefully analyzing these patterns, you can
# figure out where the mirrors are!

# To find the reflection in each pattern, you need to find a perfect reflection
# across either a horizontal line between two rows or across a vertical line
# between two columns.

# Find the line of reflection in each of the patterns in your notes. What number
# do you get after summarizing all of your notes?

require 'memoist' # maybe need to `bundle install`

EXAMPLE0 = "#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#"

EXAMPLE1 = "
#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#."

EXAMPLE2 = "
#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#"


class TestMain < Minitest::Test
  def test_run
    assert_equal(405, Main.run!(EXAMPLE0))
  end
end

class TestMap < Minitest::Test
  def test_calc_score
    map = Map.from_input(EXAMPLE1)
    assert_equal(5, map.calc_score)

    map = Map.from_input(EXAMPLE2)
    assert_equal(400, map.calc_score)
  end

  def test_horizontal_score
    map = Map.from_input(EXAMPLE1)
    assert_nil map.horizontal_score
    assert_equal(5, map.transpose.horizontal_score)

    map = Map.from_input(EXAMPLE2)
    assert_equal(4, map.horizontal_score)
    assert_nil map.transpose.horizontal_score
  end

  def test_is_a_mirror
    map = Map.from_input(EXAMPLE1)
    refute map.is_a_mirror? 1
    refute map.is_a_mirror? 4
    refute map.is_a_mirror? 7
    refute map.transpose.is_a_mirror? 1
    refute map.transpose.is_a_mirror? 2
    assert map.transpose.is_a_mirror? 5
    refute map.transpose.is_a_mirror? 6
    refute map.transpose.is_a_mirror? 9


    map = Map.from_input(EXAMPLE2)
    refute map.is_a_mirror? 6
    assert map.is_a_mirror? 4
  end
end

class Main
  class << self
    def run!(input)
      maps = input.split("\n\n").map{|str| Map.from_input(str) }
      maps.inject(0) {|sum,map| sum + map.calc_score }
    end
  end
end

# reopening utils/map.rb
class Map
  extend Memoist

  def calc_score
    unless horizontal_score.nil?
      return horizontal_score * 100
    end

    transpose.horizontal_score
  end

  def horizontal_score
    mirror = (1..row_count).find do |center|
      is_a_mirror?(center)
    end

    return nil if mirror.nil?
    mirror
  end
  memoize :horizontal_score

  def is_a_mirror?(center)
    return false if row(center).nil?
    idx1 = center
    idx2 = center - 1
    while row(idx1) && idx2 > -1
      if row(idx1) != row(idx2)
        return false
      end
      idx1 += 1
      idx2 += -1
    end
    true
  end
end
