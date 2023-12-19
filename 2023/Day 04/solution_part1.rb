# --- Day 4: Scratchcards ---

# The Elf leads you over to the pile of colorful cards. There, you discover
# dozens of scratchcards, all with their opaque covering already scratched off.
# Picking one up, it looks like each card has two lists of numbers separated by
# a vertical bar (|): a list of winning numbers and then a list of numbers you
# have. You organize the information into a table (your puzzle input).

# As far as the Elf has been able to figure out, you have to figure out which of
# the numbers you have appear in the list of winning numbers. The first match
# makes the card worth one point and each match after the first doubles the
# point value of that card.

# Take a seat in the large pile of colorful cards. How many points are they
# worth in total?

def calc_score winners, card
  overlap = winners & card
  return 0 if overlap.length == 0
  return 1 if overlap.length == 1
  2**(overlap.length-1)
end


sum = 0
File.open("./input.txt", "r") do |f|
  f.each_line do |line|
    numbers = line.split(':').last.split('|')

    winners = numbers.first.split
    card = numbers.last.split
    sum += calc_score(winners, card)
  end
end
puts sum
