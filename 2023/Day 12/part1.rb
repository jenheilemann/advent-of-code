# --- Day 12: Hot Springs ---

# There's just one problem - many of the springs have fallen into disrepair, so
# they're not actually sure which springs would even be safe to use! Worse yet,
# their condition records of which springs are damaged (your puzzle input) are
# also damaged! You'll need to help them repair the damaged records.

# In the giant field just outside, the springs are arranged into rows. For each
# row, the condition records show every spring and whether it is operational (.)
# or damaged (#). This is the part of the condition records that is itself
# damaged; for some springs, it is simply unknown (?) whether the spring is
# operational or damaged.

# However, the engineer that produced the condition records also duplicated some
# of this information in a different format! After the list of springs for a
# given row, the size of each contiguous group of damaged springs is listed in
# the order those groups appear in the row. This list always accounts for every
# damaged spring, and each number is the entire size of its contiguous group
# (that is, groups are always separated by at least one operational spring: ####
# would always be 4, never 2,2).

# However, the condition records are partially damaged; some of the springs'
# conditions are actually unknown (?). Equipped with this information, it is
# your job to figure out how many different arrangements of operational and
# broken springs fit the given criteria in each row.

# For each row, count all of the different arrangements of operational and
# broken springs that meet the given criteria. What is the sum of those counts?

EXAMPLE1 = "???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1"


class TestMain < Minitest::Test
  def test_run
    assert_equal(21, Main.run!(EXAMPLE1))
  end
end

class TestRepairTicket < Minitest::Test
  def test_from_input
    data = "???.### 1,1,3"
    ticket =  RepairTicket.from_input(data)
    assert_kind_of(RepairTicket, ticket)
    assert_equal([1,1,3], ticket.groups)
    assert_equal("???.###", ticket.map)
    assert_equal([0,1,2], ticket.unknowns)
    assert_equal(5, ticket.total)
    assert_equal(2, ticket.num_to_fill)
    assert_equal(3, ticket.broken_count)
    assert_equal(2, ticket.num_to_fill)
  end

  def test_count_the_ways
    ticket =  RepairTicket.from_input("???.### 1,1,3")
    assert_equal(1, ticket.count_the_ways )
    ticket =  RepairTicket.from_input(".??..??...?##. 1,1,3")
    assert_equal(4, ticket.count_the_ways )
    ticket =  RepairTicket.from_input("?#?#?#?#?#?#?#? 1,3,1,6")
    assert_equal(1, ticket.count_the_ways )
    ticket = RepairTicket.from_input "????.#...#... 4,1,1"
    assert_equal(1, ticket.count_the_ways)
    ticket = RepairTicket.from_input "????.######..#####. 1,6,5"
    assert_equal(4, ticket.count_the_ways)
    ticket = RepairTicket.from_input "?###???????? 3,2,1"
    assert_equal(10, ticket.count_the_ways)
  end

  def test_valid
    ticket =  RepairTicket.from_input("???.### 1,1,3")
    assert ticket.valid? '#?#.###'
    refute ticket.valid? '##?.###'

    ticket =  RepairTicket.from_input(".??..??...?##. 1,1,3")
    assert ticket.valid? '.?#..#?...###.'
    assert ticket.valid? '.?#..?#...###.'
    refute ticket.valid? '.##..#?...?##.'
    refute ticket.valid? '.??..##...###.'

    ticket = RepairTicket.from_input "?###???????? 3,2,1"
    assert ticket.valid? '?###?##?#???'
    assert ticket.valid? '?###????##?#'
    refute ticket.valid? '?###?#??##??'
    refute ticket.valid? '####????##??'
  end
end

class Main
  class << self
    def run!(input)
      lines = input.split("\n").map{|s| RepairTicket.from_input(s) }
      lines.inject(0) {|sum, o| sum + o.count_the_ways }
    end
  end
end

RepairTicket = Struct.new(:map, :groups, keyword_init: true) do
  def self.from_input(str)
    map, groups = str.split(" ")
    groups = groups.split(",").map(&:to_i)

    new(map: map, groups: groups)
  end

  def num_to_fill
    @num_to_fill ||= total - broken_count
  end

  def total
    @total ||= groups.sum
  end

  def unknowns
    @unknowns ||= map.chars.indices("?")
  end

  def broken_count
    @broken ||= map.chars.count("#")
  end

  def count_the_ways
    puts self
    matches = 0
    unknowns.combination(num_to_fill) do |possible_set|
      potential_match = map.dup
      possible_set.each {|i| potential_match[i] = "#" }
      matches += 1 if valid?(potential_match)
    end
    matches
  end

  def valid?(str)
    groups.each do |num|
      matcher = /(?:[^#]|^)(\#{#{num}})(?:[^#]|$)/
      m = matcher.match str
      return false if m.nil?
      str = m.post_match
    end
    return false if str.include? '#'
    true
  end
end
