# --- Part Two ---

# Now, you just need to put all of the packets in the right order. Disregard the
# blank lines in your list of received packets.

# The distress signal protocol also requires that you include two additional
# divider packets:

# [[2]] 6]]

# Using the same rules as before, organize all packets - the ones in your list
# of received packets as well as the two divider packets - into the correct
# order.

# Organize all of the packets into the correct order. What is the decoder key
# for the distress signal?


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

  nfirst = first.dup
  nsecond = second.dup

  # all are arrays
  while nfirst.length > 0
    f = nfirst.shift
    s = nsecond.shift
    smaller = compare(f, s)
    if smaller != 0
      return smaller
    end
  end
  if nsecond.length > 0
    return -1
  end

  return 0
end

def is_int?(item);   item.class == Integer; end
def is_array?(item); item.class == Array;   end

indices = []

pairs = File.read("input.txt").split.map{|v| eval v }
pairs << [[2]]
pairs << [[6]]

pairs.sort! { |a, b| compare a, b }
a = pairs.index([[2]]) + 1
b = pairs.index([[6]]) + 1


print a * b
