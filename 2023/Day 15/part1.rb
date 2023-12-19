# --- Day 15: Lens Library ---

# The HASH algorithm is a way to turn any string of characters into a single
# number in the range 0 to 255. To run the HASH algorithm on a string, start
# with a current value of 0. Then, for each character in the string starting
# from the beginning:

    # Determine the ASCII code for the current character of the string.
    # Increase the current value by the ASCII code you just determined.
    # Set the current value to itself multiplied by 17.
    # Set the current value to the remainder of dividing itself by 256.

# After following these steps for each character in the string in order, the
# current value is the output of the HASH algorithm.

# The initialization sequence (your puzzle input) is a comma-separated list of
# steps to start the Lava Production Facility. Ignore newline characters when
# parsing the initialization sequence. To verify that your HASH algorithm is
# working, the book offers the sum of the result of running the HASH algorithm
# on each step in the initialization sequence.

# Run the HASH algorithm on each step in the initialization sequence. What is
# the sum of the results? (The initialization sequence is one long line; be
# careful when copy-pasting it.)


EXAMPLE1 = "rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7"

class TestMain < Minitest::Test
  def test_run
    assert_equal(1320, Main.run!(EXAMPLE1))
  end
end

class TestDecoder < Minitest::Test
  def test_ascii_code
    assert_equal 72, Decoder.ascii_code('H')
    assert_equal 65, Decoder.ascii_code('A')
    assert_equal 83, Decoder.ascii_code('S')
    assert_equal 104, Decoder.ascii_code('h')
  end

  def test_decode
    assert_equal 52, Decoder.decode('HASH')
    assert_equal 30, Decoder.decode('rn=1')
    assert_equal 47, Decoder.decode('cm=2')
    assert_equal 14, Decoder.decode('qp-')
  end
end

class Main
  class << self
    def run!(input)
      input.strip.split(',').inject(0) {|sum, str| sum += Decoder.decode(str) }
    end
  end
end

class Decoder
  def self.decode(str)
    str.chars.inject(0) {|sum, char|
      sum += ascii_code(char)
      sum *= 17
      sum % 256
    }
  end

  def self.ascii_code(char)
    char.ord
  end
end
