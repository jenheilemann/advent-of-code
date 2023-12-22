# --- Day 6: Probably a Fire Hazard ---

# Because your neighbors keep defeating you in the holiday house decorating
# contest year after year, you've decided to deploy one million lights in a
# 1000x1000 grid.

# Furthermore, because you've been especially nice this year, Santa has mailed
# you instructions on how to display the ideal lighting configuration.

# Lights in your grid are numbered from 0 to 999 in each direction; the lights
# at each corner are at 0,0, 0,999, 999,999, and 999,0. The instructions include
# whether to turn on, turn off, or toggle various inclusive ranges given as
# coordinate pairs. Each coordinate pair represents opposite corners of a
# rectangle, inclusive; a coordinate pair like 0,0 through 2,2 therefore refers
# to 9 lights in a 3x3 square. The lights all start turned off.

# To defeat your neighbors this year, all you have to do is set up your lights
# by doing the instructions Santa sent you in order.

# After following the instructions, how many lights are lit?


EXAMPLE1 = <<~'EXAMPLE'
          turn on 0,0 through 999,999
          toggle 0,0 through 999,0
          turn off 499,499 through 500,500
          EXAMPLE


class TestMain < Minitest::Test
  def test_run
    assert_equal(1000*1000 - 1000 - 4, Main.run!(EXAMPLE1))
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
      lights = {}
      lines.each do |str|
        x1, y1, x2, y2 = numbers_from(str)
        (x1..x2).each do |x|
          (y1..y2).each do |y|
            case str[6]
            when 'n' # on
              lights[[x,y]] = :on
            when 'f' # off
              lights[[x,y]] = :off
            else # toggle
              lights[[x,y]] = lights[[x,y]] == :on ? :off : :on
            end
          end
        end
      end
      lights.filter{|k,v| v == :on }.length
    end

    def numbers_from(str)
      str.scan(/\d+/).map(&:to_i)
    end
  end
end
