# The Elves have made a list of all of the items currently in each rucksack
# (your puzzle input), but they need your help finding the errors. Every item
# type is identified by a single lowercase or uppercase letter (that is, a and A
#   refer to different types of items).

# The list of items for each rucksack is given as characters all on a single line.
# A given rucksack always has the same number of items in each of its two
# compartments, so the first half of the characters represent items in the first
# compartment, while the second half of the characters represent items in the
# second compartment.

# To help prioritize item rearrangement, every item type can be converted to a
# priority:

#     Lowercase item types a through z have priorities 1 through 26.
#     Uppercase item types A through Z have priorities 27 through 52.

# In the example, the priority of the item type that appears in both
# compartments of each rucksack is 16 (p), 38 (L), 42 (P), 22 (v), 20 (t), and
# 19 (s); the sum of these is 157.

# Find the item type that appears in both compartments of each rucksack. What is
# the sum of the priorities of those item types?

priorities = [0] + ("a".."z").to_a + ("A".."Z").to_a

class String
  def halves()
    chars.each_slice(size / 2).map(&:join)
  end
end

def find_misplaced(front, back)
  for char in front.chars do
    return char unless back.index(char).nil?
  end
  raise "never gets here"
end

sum = 0
File.open("./input.txt", "r") do |f|
  f.each_line do |line|
    front, back = line.strip.halves
    misplaced = find_misplaced(front,back)
    sum += priorities.index(misplaced)
  end
end

puts sum
