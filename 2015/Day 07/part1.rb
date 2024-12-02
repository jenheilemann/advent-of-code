# --- Day 7: Some Assembly Required ---

# Each wire has an identifier (some lowercase letters) and can carry a 16-bit
# signal (a number from 0 to 65535). A signal is provided to each wire by a
# gate, another wire, or some specific value. Each wire can only get a signal
# from one source, but can provide its signal to multiple destinations. A gate
# provides no signal until all of its inputs have a signal.

# The included instructions booklet describes how to connect the parts together:
# x AND y -> z means to connect wires x and y to an AND gate, and then connect
# its output to wire z.

# Other possible gates include OR (bitwise OR) and RSHIFT (right-shift). If, for
# some reason, you'd like to emulate the circuit instead, almost all programming
# languages (for example, C, JavaScript, or Python) provide operators for these
# gates.

# In little Bobby's kit's instructions booklet (provided as your puzzle input),
# what signal is ultimately provided to wire a?


EXAMPLE1 = <<~'EXAMPLE'
          123 -> x
          456 -> y
          x AND y -> d
          x OR y -> e
          x LSHIFT 2 -> f
          y RSHIFT 2 -> g
          NOT x -> h
          NOT y -> i
          EXAMPLE


class TestMain < Minitest::Test
  def test_run
    assert_equal(72, Main.run!(EXAMPLE1, 'd'))
    assert_equal(507, Main.run!(EXAMPLE1, 'e'))
    assert_equal(492, Main.run!(EXAMPLE1, 'f'))
    assert_equal(114, Main.run!(EXAMPLE1, 'g'))
    assert_equal(65412, Main.run!(EXAMPLE1, 'h'))
    assert_equal(65079, Main.run!(EXAMPLE1, 'i'))
    assert_equal(123, Main.run!(EXAMPLE1, 'x'))
    assert_equal(456, Main.run!(EXAMPLE1, 'y'))
  end
end

class Main
  class << self
    def run!(input, wire="a")
    end
  end
end
