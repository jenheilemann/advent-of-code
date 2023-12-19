# --- Day 13: Point of Incidence ---
# --- Part Two ---

# You resume walking through the valley of mirrors and - SMACK! - run directly
# into one. Hopefully nobody was watching, because that must have been pretty
# embarrassing.

# Upon closer inspection, you discover that every mirror has exactly one smudge:
# exactly one '.' or '#' should be the opposite type.

# In each pattern, you'll need to locate and fix the smudge that causes a
# different reflection line to be valid. (The old reflection line won't
# necessarily continue being valid after the smudge is fixed.)

# Summarize your notes as before, but instead use the new different reflection
# lines.

# In each pattern, fix the smudge and find the different line of reflection.
# What number do you get after summarizing the new reflection line in each
# pattern in your notes?

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
    assert_equal(400, Main.run!(EXAMPLE0))
  end
end

class TestMap < Minitest::Test
  def test_calc_score
    map = Map.from_input(EXAMPLE1)
    assert_equal(300, map.calc_score)

    map = Map.from_input(EXAMPLE2)
    assert_equal(100, map.calc_score)
  end

  def test_horizontal_score
    map = Map.from_input(EXAMPLE1)
    assert_nil map.transpose.horizontal_score
    assert_equal(3, map.horizontal_score)

    map = Map.from_input(EXAMPLE2)
    assert_equal(1, map.horizontal_score)
    assert_nil map.transpose.horizontal_score
  end

  def test_is_a_mirror
    map = Map.from_input(EXAMPLE1)
    refute map.is_a_mirror? 1
    assert map.is_a_mirror? 3
    refute map.is_a_mirror? 4
    refute map.is_a_mirror? 7
    refute map.transpose.is_a_mirror? 1
    refute map.transpose.is_a_mirror? 2
    refute map.transpose.is_a_mirror? 5
    refute map.transpose.is_a_mirror? 6
    refute map.transpose.is_a_mirror? 9


    map = Map.from_input(EXAMPLE2)
    refute map.is_a_mirror? 6
    refute map.is_a_mirror? 4
    assert map.is_a_mirror? 1
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

  def is_a_mirror?(center)
    return false if row(center).nil?
    idx1 = center
    idx2 = center - 1
    off_by_one = 0
    while row(idx1) && idx2 > -1
      if row(idx1) != row(idx2)
        if row(idx1).to_a.indices{|v,i| row(idx2)[i] != v }.length > 1
          return false
        end
        off_by_one += 1
      end
      idx1 += 1
      idx2 += -1
    end
    true && off_by_one == 1
  end
end
