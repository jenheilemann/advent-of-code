# --- Day 2: I Was Told There Would Be No Math ---

# Find the surface area of the box, which is 2*l*w + 2*w*h + 2*h*l. The elves
# also need a little extra paper for each present: the area of the smallest
# side.

# All numbers in the elves' list are in feet. How many total square feet of
# wrapping paper should they order?


EXAMPLE1 = <<~'EXAMPLE'
          2x3x4
          1x1x10
          EXAMPLE


class TestMain < Minitest::Test
  def test_run
    assert_equal(58+43, Main.run!(EXAMPLE1))
  end

  def test_wrapping_paper
    assert_equal(43, Main.wrapping_paper('1x1x10'))
    assert_equal(58, Main.wrapping_paper('2x3x4'))
  end
end

class Main
  class << self
    def run!(input)
      boxes = input.strip.split("\n")
      boxes.sum {|b| wrapping_paper(b) }
    end

    def wrapping_paper(str)
      sides = str.split('x').combination(2).map {|f,s| 2*f.to_i*s.to_i }
      sides.sum + sides.min/2
    end
  end
end
