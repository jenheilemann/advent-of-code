# --- Part Two ---

# As you scan through the corrupted memory, you notice that some of the
# conditional statements are also still intact. If you handle some of the
# uncorrupted conditional statements in the program, you might be able to get an
# even more accurate result.

# There are two new instructions you'll need to handle:

#     The do() instruction enables future mul instructions.
#     The don't() instruction disables future mul instructions.

# Only the most recent do() or don't() instruction applies. At the beginning of
# the program, mul instructions are enabled.

# Handle the new instructions; what do you get if you add up all of the results
# of just the enabled multiplications?


EXAMPLE1 = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
# 2*4 + 8*5 = 48

class TestMain < Minitest::Test
  def test_run
    assert_equal(48, Main.run!(EXAMPLE1))
  end
end

class Main
  class << self
    def run!(input)
      mul_matcher = /mul\((\d{1,3}\,\d{1,3})\)|(do|don't)\(\)/
      mul_instances = input.scan(mul_matcher)

      doo = true
      multiply = []
      mul_instances.each do |v|
        if doo && !v[0].nil?
          a,b = v[0].split(',')
          multiply.push a.to_i * b.to_i
        elsif !v[1].nil?
          doo = v[1] == 'do'
        end
      end

      multiply.sum
    end
  end
end
