# --- Day 12: Hot Springs ---
# --- Part Two ---

# As you look out at the field of springs, you feel like there are way more
# springs than the condition records list. When you examine the records, you
# discover that they were actually folded up this whole time!

# To unfold the records, on each row, replace the list of spring conditions with
# five copies of itself (separated by ?) and replace the list of contiguous
# groups of damaged springs with five copies of itself (separated by ,).

# So, this row:

# .# 1

# Would become:

# .#?.#?.#?.#?.# 1,1,1,1,1

# The first line of the example would become:

# ???.###????.###????.###????.###????.### 1,1,3,1,1,3,1,1,3,1,1,3,1,1,3

# After unfolding, adding all of the possible arrangement counts together
# produces 525152.

# Unfold your condition records; what is the new sum of possible arrangement
# counts?

require 'memoist' # maybe need to `gem install memoist`

EXAMPLE1 = "???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1"


class TestMain < Minitest::Test
  def test_run
    assert_equal(525152, Main.run!(EXAMPLE1))
  end
end

class TestRepairTicket < Minitest::Test
  def test_from_input
    data = "???.### 1,1,3"
    ticket =  RepairTicket.from_input(data)
    assert_kind_of(RepairTicket, ticket)
    assert_equal([1,1,3,1,1,3,1,1,3,1,1,3,1,1,3], ticket.groups)
    assert_equal("???.###????.###????.###????.###????.###", ticket.map)
  end

  def test_count_the_ways
    ticket =  RepairTicket.from_input("???.### 1,1,3")
    assert_equal(1, ticket.count_the_ways )
    ticket =  RepairTicket.from_input(".??..??...?##. 1,1,3")
    assert_equal(16384, ticket.count_the_ways )
    ticket =  RepairTicket.from_input("?#?#?#?#?#?#?#? 1,3,1,6")
    assert_equal(1, ticket.count_the_ways )
    ticket = RepairTicket.from_input "????.#...#... 4,1,1"
    assert_equal(16, ticket.count_the_ways)
    ticket = RepairTicket.from_input "????.######..#####. 1,6,5"
    assert_equal(2500, ticket.count_the_ways)
    ticket = RepairTicket.from_input "?###???????? 3,2,1"
    assert_equal(506250, ticket.count_the_ways)
  end

  def test_valid_group
    ticket =  RepairTicket.from_input("???.### 1,1,3")
    # map = ???.###????.###????.###????.###????.###
    refute ticket.valid_group 3, 3
    assert ticket.valid_group 4, 3
    assert ticket.valid_group 5, 3

    ticket =  RepairTicket.from_input(".??..??...?##. 1,1,3")
    # map = .??..??...?##.?.??..??...?##.?.??..??...?##.?.??..??...?##.?.??..??...?##.
    refute ticket.valid_group 1, 3
    refute ticket.valid_group 9, 3
    assert ticket.valid_group 10, 3

    ticket = RepairTicket.from_input "?###???????? 3,2,1"
    # map = ?###??????????###??????????###??????????###??????????###????????
    refute ticket.valid_group 1, 2
    refute ticket.valid_group 14, 1
    refute ticket.valid_group 12, 3
    assert ticket.valid_group 10, 3
    assert ticket.valid_group 14, 3
  end
end

class Main
  class << self
    def run!(input)
      input.split("\n").inject(0) {|sum, s| sum + RepairTicket.from_input(s).count_the_ways }
    end
  end
end

RepairTicket = Struct.new(:map, :groups, keyword_init: true) do
  extend Memoist

  def self.from_input(str)
    map, groups = str.split(" ")
    groups = groups.split(",").map(&:to_i) * 5
    map = ([map] * 5).join('?')

    new(map: map, groups: groups)
  end

  def count_the_ways
    recur(0, 0)
  end

  def recur(position, group_id)
    if group_id == groups.length
      return 1 if position > map.length
      return 1 if map[position..].count('#') == 0
      return 0
    end
    return 0 if position >= map.length

    if map[position] == '#'
      if valid_group(position, groups[group_id])
        return recur(position+groups[group_id]+1, group_id+1)
      else
        return 0
      end
    end

    if valid_group(position, groups[group_id])
      return recur(position+groups[group_id]+1, group_id+1) +
             recur(position + 1, group_id)
    end
    recur(position + 1, group_id)
  end
  memoize :recur

  def valid_group(start, length)
    finish = start+length
    row = map[start...finish]
    return false if row.count('.') != 0
    return false if row.length != length
    finish >= map.length || map[finish] == '.' || map[finish] == '?'
  end
end
