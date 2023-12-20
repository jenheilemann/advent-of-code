# --- Day 2: I Was Told There Would Be No Math ---
# --- Part Two ---

# The ribbon required to wrap a present is the shortest distance around its
# sides, or the smallest perimeter of any one face. Each present also requires a
# bow made out of ribbon as well; the feet of ribbon required for the perfect
# bow is equal to the cubic feet of volume of the present. Don't ask how they
# tie the bow, though; they'll never tell.

# How many total feet of ribbon should they order?



EXAMPLE1 = <<~'EXAMPLE'
          2x3x4
          1x1x10
          EXAMPLE


class TestMain < Minitest::Test
  def test_run
    assert_equal(34+14, Main.run!(EXAMPLE1))
  end

  def test_ribbon_wrap
    assert_equal(4, Main.ribbon_wrap([1,1,10]))
    assert_equal(10, Main.ribbon_wrap([2,3,4]))
  end

  def test_bow
    assert_equal(10, Main.bow([1,1,10]))
    assert_equal(24, Main.bow([2,3,4]))
  end
end

class Main
  class << self
    def run!(input)
      boxes = input.strip.split("\n").map{|s| s.split('x').map(&:to_i) }
      boxes.sum {|b| ribbon_wrap(b) + bow(b) }
    end

    def bow(dims)
      dims.inject(1, &:*)
    end

    def ribbon_wrap(dims)
      dims.sort!
      dims[0] + dims[1] + dims[0] + dims[1]
    end
  end
end
