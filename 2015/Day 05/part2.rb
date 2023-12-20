# --- Day 5: Doesn't He Have Intern-Elves For This? ---
# --- Part Two ---

# Now, a nice string is one with all of the following properties:

#     It contains a pair of any two letters that appears at least twice in the
#       string without overlapping, like xyxy (xy) or aabcdefgaa (aa), but not
#       like aaa (aa, but it overlaps).
#     It contains at least one letter which repeats with exactly one letter
#       between them, like xyx, abcdefeghi (efe), or even aaa.

# How many strings are nice under these new rules?

EXAMPLE1 = <<~'EXAMPLE'
          qjhvhtzxzqqjkmpb
          xxyxx
          uurcxstgmygtbstg
          ieodomkazucvgmuy
          EXAMPLE


class TestMain < Minitest::Test
  def test_run
    assert_equal(2, Main.run!(EXAMPLE1))
  end

  def test_nice
    assert Main.nice?('qjhvhtzxzqqjkmpb')
    assert Main.nice?('xxyxx')
    refute Main.nice?('uurcxstgmygtbstg')
    refute Main.nice?('ieodomkazucvgmuy')
  end
end

class Main
  MIRRORED = Regexp.new(/(\w)\w(\1)/).freeze
  MATCHING = Regexp.new(/(\w\w).*(\1)/).freeze
  class << self
    def run!(input)
      input.strip.split("\n").filter{|s| nice? s }.length
    end

    def nice? str
      return false unless MIRRORED.match? str
      return false unless MATCHING.match? str
      true
    end
  end
end
