# --- Day 9: Mirage Maintenance ---

# You pull out your handy Oasis And Sand Instability Sensor and analyze your
# surroundings. The OASIS produces a report of many values and how they are
# changing over time (your puzzle input). Each line in the report contains the
# history of a single value.

# To best protect the oasis, your environmental report should include a
# prediction of the next value in each history. To do this, start by making a
# new sequence from the difference at each step of your history. If that
# sequence is not all zeroes, repeat this process, using the sequence you just
# generated as the input sequence. Once all of the values in your latest
# sequence are zeroes, you can extrapolate what the next value of the original
# history should be.

# Analyze your OASIS report and extrapolate the next value for each history.
# What is the sum of these extrapolated values?


class TestMain < Minitest::Test
  def example1
    "0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45"
  end

  def test_run
    assert_equal(114, Main.run!(example1))
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
end

class Main
  class << self
    def run!(input)
      inputs = input.split("\n")
      reports = inputs.map{|str| Report.from_input(str)}
      reports.inject(0) { |sum,r| sum + r.next_value }
    end

  end
end

Report = Struct.new(:readings, keyword_init: true) do
  class << self
    def from_input(str)
      self.new(readings: str.split.map(&:to_i))
    end
  end

  def next_value
    next_recursive(readings)
  end

  def next_recursive(diffs)
    return diffs.first if diffs.all?(diffs.first)

    diffs.last + next_recursive(diffs.each_cons(2).map{|v| v.last - v.first })
  end
end
