# --- Part Two ---

# You're worried you might not ever get your items back. So worried, in fact,
# that your relief that a monkey's inspection didn't damage an item no longer
# causes your worry level to be divided by three.

# Unfortunately, that relief was all that was keeping your worry levels from
# reaching ridiculous levels. You'll need to find another way to keep your worry
# levels manageable.

# At this rate, you might be putting up with these monkeys for a very long time
# - possibly 10000 rounds!

# With these new rules, you can still figure out the monkey business after 10000
# rounds.

# Worry levels are no longer divided by three after each item is inspected;
# you'll need to find another way to keep your worry levels manageable. Starting
# again from the initial state in your puzzle input, what is the level of monkey
# business after 10000 rounds?

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
  def modulo; @modulo; end

  def turn(monkeys, modulos)
    @items.each do |item|
      @inspection_count += 1
      new_worry = monkey_inspect(item)
      monkeys[monkey_test(new_worry)].catch(new_worry%modulos)
    end
    @items = []
  end

  def monkey_inspect(item)
    @operation.call(item)
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
modulos = monkeys.map(&:modulo).inject(1, :*)
print monkeys.map{|m| [m.items, m.inspection_count]}, "\n"

10_000.times do |i|
  # puts "turn #{i}"
  monkeys.each do |monkey|
    monkey.turn(monkeys, modulos)
  end
  # print monkeys.map{|m| [m.items, m.inspection_count]}, "\n"
end

print monkeys.map{|m| [m.items, m.inspection_count]}, "\n"
print monkeys.map(&:inspection_count).sort
