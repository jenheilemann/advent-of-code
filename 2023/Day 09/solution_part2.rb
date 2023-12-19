# --- Day 9: Mirage Maintenance --- Part Two ---

# Of course, it would be nice to have even more history included in your report.
# Surely it's safe to just extrapolate backwards as well, right?

# For each history, repeat the process of finding differences until the sequence
# of differences is entirely zero. Then, rather than adding a zero to the end
# and filling in the next values of each previous sequence, you should instead
# add a zero to the beginning of your sequence of zeroes, then fill in new first
# values for each previous sequence.

# Analyze your OASIS report again, this time extrapolating the previous value
# for each history. What is the sum of these extrapolated values?


class TestMain < Minitest::Test
  def example1
    "0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45"
  end

  def test_run
    assert_equal(2, Main.run!(example1))
  end
end

class TestReport < Minitest::Test
  def test_from_input
    report = Report.from_input('0 2 4')
    assert_equal([0,2,4], report.readings)
  end

  def test_next_value
    report = Report.from_input('0 2 4')
    assert_equal(6, report.next_value)
    report = Report.from_input('0 3 6 9 12 15')
    assert_equal(18, report.next_value)
    report = Report.from_input('1 3 6 10 15 21')
    assert_equal(28, report.next_value)
    report = Report.from_input('10 13 16 21 30 45')
    assert_equal(68, report.next_value)
  end

  def test_previous_value
    report = Report.from_input('0 2 4')
    assert_equal(-2, report.previous_value)
    report = Report.from_input('0 3 6 9 12 15')
    assert_equal(-3, report.previous_value)
    report = Report.from_input('1 3 6 10 15 21')
    assert_equal(0, report.previous_value)
    report = Report.from_input('10 13 16 21 30 45')
    assert_equal(5, report.previous_value)
  end
end

class Main
  class << self
    def run!(input)
      inputs = input.split("\n")
      reports = inputs.map{|str| Report.from_input(str)}
      reports.inject(0) { |sum,r| sum + r.previous_value }
    end

  end
end

Report = Struct.new(:readings, keyword_init: true) do
  class << self
    def from_input(str)
      self.new(readings: str.split.map(&:to_i))
    end
  end

  def previous_value
    previous_recursive(readings)
  end

  def previous_recursive(diffs)
    return diffs.first if diffs.all?(diffs.first)
    diffs.first - previous_recursive(diffs.each_cons(2).map{|v| v.last - v.first })

  end

  def next_value
    next_recursive(readings)
  end

  def next_recursive(diffs)
    return diffs.first if diffs.all?(diffs.first)

    diffs.last + next_recursive(diffs.each_cons(2).map{|v| v.last - v.first })
  end
end
