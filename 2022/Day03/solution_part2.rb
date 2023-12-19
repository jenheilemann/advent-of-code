# Every Elf carries a badge that identifies their group. For efficiency, within
# each group of three Elves, the badge is the only item type carried by all three
# Elves. That is, if a group's badge is item type B, then all three Elves will
# have item type B somewhere in their rucksack, and at most two of the Elves will
# be carrying any other item type.

# The problem is that someone forgot to put this year's updated authenticity
# sticker on the badges. All of the badges need to be pulled out of the rucksacks
# so the new authenticity stickers can be attached.

# Additionally, nobody wrote down which item type corresponds to each group's
# badges. The only way to tell which item type is the right one is by finding the
# one item type that is common between all three Elves in each group.

# Every set of three lines in your list corresponds to a single group, but each
# group can have a different badge item type.

priorities = [0] + ("a".."z").to_a + ("A".."Z").to_a

def find_badge(group)
  for char in group[0].chars do
    return char if !group[1].index(char).nil? && !group[2].index(char).nil?
  end
  raise "never gets here"
end

sum = 0

file_data = File.read("input.txt").split
file_data.each_slice(3) do |group|
  badge = find_badge(group)
  sum += priorities.index(badge)
end

puts sum
