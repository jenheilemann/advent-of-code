# --- Day 2: Red-Nosed Reports ---
# --- Part Two ---

# Now, the same rules apply as before, except if removing a single level from an
# unsafe report would make it safe, the report instead counts as safe.

# More of the above example's reports are now safe:

#     7 6 4 2 1: Safe without removing any level.
#     1 2 7 8 9: Unsafe regardless of which level is removed.
#     9 7 6 2 1: Unsafe regardless of which level is removed.
#     1 3 2 4 5: Safe by removing the second level, 3.
#     8 6 4 4 1: Safe by removing the third level, 4.
#     1 3 6 7 9: Safe without removing any level.

# Thanks to the Problem Dampener, 4 reports are actually safe!

# Update your analysis by handling situations where the Problem Dampener can
# remove a single level from unsafe reports. How many reports are now safe?

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
    assert_equal(4, Main.run!(EXAMPLE1))
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
    assert(Report.new([1,3,2,4,5]).safe?)
    assert(Report.new([8,6,4,4,1]).safe?)
    assert(Report.new([1,3,6,7,9]).safe?)

    assert(Report.new([5,7,6,4,2,1]).safe?, "5,7,6,4,2,1 should be safe.")
    refute(Report.new([7,7,6,4,2,1,1]).safe?, "5,7,6,4,2,1,1 should not be safe.")
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
    asc = values[0] < values.last
    bad_idx = find_bad_idx(values, asc)
    return true if bad_idx.nil?


    new_arr = values.clone
    # print "\nSnooping inside #{new_arr}, idx #{bad_idx} seems to cause problems"
    new_arr.delete_at(bad_idx)
    # print "\n#{new_arr}"
    asc = new_arr[0] < new_arr.last
    return true if find_bad_idx(new_arr,asc).nil?

    new_arr = values.clone
    # print "\nStill snooping #{new_arr}, idx #{bad_idx+1} might be the problem"
    new_arr.delete_at(bad_idx+1)
    # print "\n#{new_arr}"
    asc = new_arr[0] < new_arr.last
    return true if find_bad_idx(new_arr,asc).nil?
    false
  end

  def find_bad_idx(vals, asc)
    vals.each_cons(2).with_index do |vals,idx|
      a, b = vals
      if (asc && a >= b) || (!asc && a <= b)
        return idx
      end
      if (a-b).abs > 3
        return idx
      end
    end
    nil
  end
end
