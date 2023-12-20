# --- Day 5: Doesn't He Have Intern-Elves For This? ---

# A nice string is one with all of the following properties:

    # It contains at least three vowels (aeiou only), like aei, xazegov.
    # It contains at least one letter that appears twice in a row, like xx, abcdde
    # It does not contain the strings ab, cd, pq, or xy, even if they are part
    #   of one of the other requirements.

# How many strings are nice?


EXAMPLE1 = <<~'EXAMPLE'
          ugknbfddgicrmopn
          aaa
          jchzalrnumimnmhp
          haegwjzuvuyypxyu
          dvszwmarrgswjxmb
          EXAMPLE


class TestMain < Minitest::Test
  def test_run
    assert_equal(2, Main.run!(EXAMPLE1))
  end

  def test_nice
    assert Main.nice?('ugknbfddgicrmopn')
    assert Main.nice?('aaa')
    refute Main.nice?('jchzalrnumimnmhp')
    refute Main.nice?('haegwjzuvuyypxyu')
    refute Main.nice?('dvszwmarrgswjxmb')
  end
end

class Main
  DISALLOWED = Regexp.new(/ab|cd|pq|xy/).freeze
  VOWELS = Regexp.new(/[aeiou]/).freeze
  INAROW = Regexp.new(/aa|bb|cc|dd|ee|ff|gg|hh|ii|jj|kk|ll|mm|nn|oo|pp|qq|rr|ss|tt|uu|vv|ww|xx|yy|zz/).freeze
  class << self
    def run!(input)
      input.strip.split("\n").filter{|s| nice? s }.length
    end

    def nice? str
      return false if DISALLOWED.match? str
      return false unless INAROW.match? str
      return false unless str.scan(VOWELS).length >=3
      true
    end
  end
end
