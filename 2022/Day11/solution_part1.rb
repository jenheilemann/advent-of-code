# --- Day 11: Monkey in the Middle ---

# As you finally start making your way upriver, you realize your pack is much
# lighter than you remember. Just then, one of the items from your pack goes
# flying overhead. Monkeys are playing Keep Away with your missing things!

# To get your stuff back, you need to be able to predict where the monkeys will
# throw your items. After some careful observation, you realize the monkeys
# operate based on how worried you are about each item.

# You take some notes (your puzzle input) on the items each monkey currently
# has, how worried you are about those items, and how the monkey makes decisions
# based on your worry level. For example:

# Each monkey has several attributes:

#     Starting items lists your worry level for each item the monkey is
#                    currently holding in the order they will be inspected.
#     Operation shows how your worry level changes as that monkey inspects an
#                     item. (An operation like new = old * 5 means that your
#                     worry level after the monkey inspected the item is five
#                     times whatever your worry level was before inspection.)
#     Test shows how the monkey uses your worry level to decide where to throw
#          an item next.
#         If true shows what happens with an item if the Test was true.
#         If false shows what happens with an item if the Test was false.

# After each monkey inspects an item but before it tests your worry level, your
# relief that the monkey's inspection didn't damage the item causes your worry
# level to be divided by three and rounded down to the nearest integer.

# The monkeys take turns inspecting and throwing items. On a single monkey's
# turn, it inspects and throws all of the items it is holding one at a time and
# in the order listed. Monkey 0 goes first, then monkey 1, and so on until each
# monkey has had one turn. The process of each monkey taking a single turn is
# called a round.

# When a monkey throws an item to another monkey, the item goes on the end of
# the recipient monkey's list. A monkey that starts a round with no items could
# end up inspecting and throwing many items by the time its turn comes around.
# If a monkey is holding no items at the start of its turn, its turn ends.

# Chasing all of the monkeys at once is impossible; you're going to have to
# focus on the two most active monkeys if you want any hope of getting your
# stuff back. Count the total number of times each monkey inspects items over 20
# rounds:

# Figure out which monkeys to chase by counting how many items they inspect over
# 20 rounds. What is the level of monkey business after 20 rounds of
# stuff-slinging simian shenanigans?

class Monkey
  def initialize(starting_items, operation, modulo, truish, falseish)
    @items = starting_items
    @operation = operation
    @modulo = modulo
    @truish = truish
    @falseish = falseish

    @inspection_count = 0
  end
  def items; @items; end
  def inspection_count; @inspection_count; end

  def turn(monkeys)
    @items.each do |item|
      @inspection_count += 1
      new_worry = monkey_inspect(item)
      monkeys[monkey_test(new_worry)].catch(new_worry)
    end
    @items = []
  end

  def monkey_inspect(item)
    @operation.call(item)/3
  end

  def monkey_test(item)
    item % @modulo == 0 ? @truish : @falseish
  end

  def catch(item)
    @items << item
  end
end

# Example monkeys:
# monkeys = [
#   Monkey.new([79, 98], ->(x) {x * 19}, 23, 2, 3),
#   Monkey.new([54, 65, 75, 74], ->(x) { x  + 6}, 19, 2, 0),
#   Monkey.new([79, 60, 97], -> (x) {x**2}, 13, 1, 3),
#   Monkey.new([74], -> (x) { x + 3}, 17, 0, 1),
# ]

monkeys = [
  Monkey.new([56, 56, 92, 65, 71, 61, 79], ->(x) {x * 7}, 3, 3, 7),
  Monkey.new([61, 85], ->(x) {x + 5}, 11, 6, 4),
  Monkey.new([54, 96, 82, 78, 69], ->(x) {x * x}, 7, 0, 7),
  Monkey.new([57, 59, 65, 95], ->(x) {x + 4}, 2, 5, 1),
  Monkey.new([62, 67, 80], ->(x) {x * 17}, 19, 2, 6),
  Monkey.new([91], ->(x) {x + 7}, 5, 1, 4),
  Monkey.new([79, 83, 64, 52, 77, 56, 63, 92], ->(x) {x + 6}, 17, 2, 0),
  Monkey.new([50, 97, 76, 96, 80, 56], ->(x) {x + 3}, 13, 3, 5),
]

print monkeys.map{|m| [m.items, m.inspection_count]}, "\n"
20.times do |i|
  puts "turn #{i}"
  monkeys.each do |monkey|
    monkey.turn(monkeys)
  end
  print monkeys.map{|m| [m.items, m.inspection_count]}, "\n"
end

