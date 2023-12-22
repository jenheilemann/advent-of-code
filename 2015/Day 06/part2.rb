# --- Day 6: Probably a Fire Hazard ---
# --- Part Two ---

# The light grid you bought actually has individual brightness controls; each
# light can have a brightness of zero or more. The lights all start at zero.

# The phrase turn on actually means that you should increase the brightness of
# those lights by 1.

# The phrase turn off actually means that you should decrease the brightness of
# those lights by 1, to a minimum of zero.

# The phrase toggle actually means that you should increase the brightness of
# those lights by 2.

# What is the total brightness of all lights combined after following Santa's
# instructions?

EXAMPLE1 = <<~'EXAMPLE'
          turn on 0,0 through 999,999
          toggle 0,0 through 999,0
          turn off 499,499 through 500,500
          EXAMPLE


class TestMain < Minitest::Test
  def test_run
    assert_equal(1000000 + 2000 - 4, Main.run!(EXAMPLE1))
  end

  def test_numbers_from
    assert_equal [0,0,999,999], Main.numbers_from('turn on 0,0 through 999,999')
    assert_equal [0,0,999,0], Main.numbers_from('toggle 0,0 through 999,0')
    assert_equal [499,499,500,500], Main.numbers_from('turn off 499,499 through 500,500')
  end
end

class Main
  class << self
    def run!(input)
      lines = input.strip.split("\n")
      lights = Hash.new{ 0 }
      lines.each do |str|
        x1, y1, x2, y2 = numbers_from(str)
        (x1..x2).each do |x|
          (y1..y2).each do |y|
            case str[6]
            when 'n' # on
              lights[[x,y]] += 1
            when 'f' # off
              if lights[[x,y]] > 0
                lights[[x,y]] -= 1
              end
            else # toggle
              lights[[x,y]] += 2
            end
          end
        end
      end
      lights.values.sum
    end

    def numbers_from(str)
      str.scan(/\d+/).map(&:to_i)
    end
  end
end
