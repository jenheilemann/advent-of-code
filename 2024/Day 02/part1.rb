# --- Day 2: Red-Nosed Reports ---

# The unusual data (your puzzle input) consists of many reports, one report per
# line. Each report is a list of numbers called levels that are separated by
# spaces.

# The engineers are trying to figure out which reports are safe. The Red-Nosed
# reactor safety systems can only tolerate levels that are either gradually
# increasing or gradually decreasing. So, a report only counts as safe if both
# of the following are true:

#     The levels are either all increasing or all decreasing. Any two adjacent
#     levels differ by at least one and at most three.

# In the example above, the reports can be found safe or unsafe by checking
# those rules:

#     7 6 4 2 1: Safe because the levels are all decreasing by 1 or 2.
#     1 2 7 8 9: Unsafe because 2 7 is an increase of 5.
#     9 7 6 2 1: Unsafe because 6 2 is a decrease of 4.
#     1 3 2 4 5: Unsafe because 1 3 is increasing but 3 2 is decreasing.
#     8 6 4 4 1: Unsafe because 4 4 is neither an increase or a decrease.
#     1 3 6 7 9: Safe because the levels are all increasing by 1, 2, or 3.

# So, in this example, 2 reports are safe.

# Analyze the unusual data from the engineers. How many reports are safe?

EXAMPLE1 = <<~'EXAMPLE'
7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
          EXAMPLE


class TestMain < Minitest::Test
  def test_run
    assert_equal(2, Main.run!(EXAMPLE1))
  end
end

class TestReport < Minitest::Test
  def test_from_input
    report = Report.from_input("1 2 6")
    assert_equal(report.class, Report)
    assert_equal(report.values, [1,2,6])
  end

  def test_safe?
    assert(Report.new([7,6,4,2,1]).safe?)
    refute(Report.new([1,2,7,8,9]).safe?)
    refute(Report.new([9,7,6,2,1]).safe?)
    refute(Report.new([1,3,2,4,5]).safe?)
    refute(Report.new([8,6,4,4,1]).safe?)
    assert(Report.new([1,3,6,7,9]).safe?)
  end
end

class Main
  class << self
    def run!(input)
      input.strip.split("\n").map{|v| Report.from_input(v)}.count{|r| r.safe? }
    end
  end
end

class Report
  class << self
    def from_input(input)
      nums = input.strip.split(" ").map(&:to_i)
      new(nums)
    end
  end

  attr_reader :values
  def initialize(vals)
    @values = vals
  end

  def safe?
    asc = nil
    values.each_cons(2) do |a, b|
      if asc.nil?
        asc = a < b
      end
      if (asc && a >= b) || (!asc && a <= b)
        return false
      end
      if (a-b).abs > 3
        return false
      end
    end
    true
  end
end
