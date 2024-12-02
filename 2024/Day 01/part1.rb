# --- Day 1: Historian Hysteria ---
# Throughout the Chief's office, the historically significant locations are
# listed not by name but by a unique number called the location ID. To make sure
# they don't miss anything, The Historians split into two groups, each searching
# the office and trying to create their own complete list of location IDs.

# There's just one problem: by holding the two lists up side by side (your
# puzzle input), it quickly becomes clear that the lists aren't very similar.
# Maybe you can help The Historians reconcile their lists?

# Maybe the lists are only off by a small amount! To find out, pair up the
# numbers and measure how far apart they are. Pair up the smallest number in the
# left list with the smallest number in the right list, then the second-smallest
# left number with the second-smallest right number, and so on.

# Within each pair, figure out how far apart the two numbers are; you'll need to
# add up all of those distances. For example, if you pair up a 3 from the left
# list with a 7 from the right list, the distance apart is 4; if you pair up a 9
# with a 3, the distance apart is 6.

# To find the total distance between the left list and the right list, add up
# the distances between all of the pairs you found. In the example above, this
# is 2 + 1 + 0 + 1 + 2 + 5, a total distance of 11!


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
    assert_equal(11, Main.run!(EXAMPLE1))
  end
end

class Main
  class << self
    def run!(input)
      list1, list2 = parse(input.strip.split("\n"))
      list1.sort!
      list2.sort!
      list1.length.times.inject(0) { |sum, idx| sum += (list1[idx] - list2[idx]).abs }
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
