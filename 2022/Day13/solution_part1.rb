# --- Day 13: Distress Signal ---

# You climb the hill and again try contacting the Elves. However, you instead
# receive a signal you weren't expecting: a distress signal.

# Your handheld device must still not be working properly; the packets from the
# distress signal got decoded out of order. You'll need to re-order the list of
# received packets (your puzzle input) to decode the message.

# Your list consists of pairs of packets; pairs are separated by a blank line.
# You need to identify how many pairs of packets are in the right order.

# What are the indices of the pairs that are already in the right order? (The
# first pair has index 1, the second pair has index 2, and so on.) In the
# example, the pairs in the right order are 1, 2, 4, and 6; the sum of these
# indices is 13.

# Determine which pairs of packets are already in the right order. What is the
# sum of the indices of those pairs?


def compare first, second
  puts "Called :compare(#{first}, #{second})"
  if [first, second].all? {|v| is_int?(v) }
    puts "returning first #{first} <=> second #{second} #=> #{first <=> second}"
    return first <=> second
  end

  if first.nil? && !second.nil?
    return -1
  end
  if !first.nil? && second.nil?
    return 1
  end

  if !is_array?(first) && is_array?(second)
    first = [ first ]
  end
  if !is_array?(second) && is_array?(first)
    second = [ second ]
  end

  if first.nil?
    return -1
  end
  if second.nil?
    return 1
  end

  # all are arrays
  while first.length > 0
    f = first.shift
    s = second.shift
    smaller = compare(f, s)
    if smaller != 0
      return smaller
    end
  end
  if second.length > 0
    return -1
  end

  return 0
end

def is_int?(item);   item.class == Integer; end
def is_array?(item); item.class == Array;   end

indices = []

pairs = File.read("input.txt").split("\n\n").map(&:split)
pairs.each_with_index do |pair, i|
  first, second = pair.map{|v| eval v }
  print first, "  :  ", second, "\n"
  smaller = compare first, second
  # require 'pry'; binding.pry
  if smaller == -1
    indices << i + 1
    puts "indices now :#{indices}"
  end
end

print indices
puts indices.sum
