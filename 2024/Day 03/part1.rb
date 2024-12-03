# --- Day 3: Mull It Over ---

# The computer appears to be trying to run a program, but its memory (your
# puzzle input) is corrupted. All of the instructions have been jumbled up!

# It seems like the goal of the program is just to multiply some numbers. It
# does that with instructions like mul(X,Y), where X and Y are each 1-3 digit
# numbers. For instance, mul(44,46) multiplies 44 by 46 to get a result of 2024.
# Similarly, mul(123,4) would multiply 123 by 4.

# However, because the program's memory has been corrupted, there are also many
# invalid characters that should be ignored, even if they look like part of a
# mul instruction. Sequences like mul(4*, mul(6,9!, ?(12,34), or mul ( 2 , 4 )
# do nothing.

# Scan the corrupted memory for uncorrupted mul instructions. What do you get if
# you add up all of the results of the multiplications?


EXAMPLE1 = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
# 2*4 + 5*5 + 11*8 + 8*5 = 161


class TestMain < Minitest::Test
  def test_run
    assert_equal(161, Main.run!(EXAMPLE1))
  end
end

class Main

  class << self
    def run!(input)
      mul_matcher = /mul\((\d{1,3}\,\d{1,3})\)/
      mul_instances = input.scan(mul_matcher)
      multiply = mul_instances.map {|v| a,b = v[0].split(','); a.to_i * b.to_i }
      multiply.sum
    end
  end
end
