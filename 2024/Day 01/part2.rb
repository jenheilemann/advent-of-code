# --- Day 1: Historian Hysteria ---

# This time, you'll need to figure out exactly how often each number from the
# left list appears in the right list. Calculate a total similarity score by
# adding up each number in the left list after multiplying it by the number of
# times that number appears in the right list.

# So, for the example, the similarity score at the end of this process is 31 (9
# + 4 + 0 + 0 + 9 + 9).

# Once again consider your left and right lists. What is their similarity score?

EXAMPLE1 = <<~'EXAMPLE'
3   4
4   3
2   5
1   3
3   9
3   3
          EXAMPLE


class TestMain < Minitest::Test
  def test_run
    assert_equal(31, Main.run!(EXAMPLE1))
  end
end

class Main
  class << self
    def run!(input)
      list1, list2 = parse(input.strip.split("\n"))
      tally = list1.tally
      list2.inject(0) { |sum, val| sum += (tally[val] || 0) * val }
    end

    def parse(input)
      list1, list2 = [], []
      input.each do |line|
        v1, v2 = line.split('   ')
        list1.push v1.to_i
        list2.push v2.to_i
      end
      return list1, list2
    end
  end
end
