# --- Day 5: Supply Stacks ---

# The expedition can depart as soon as the final supplies have been unloaded from
# the ships. Supplies are stored in stacks of marked crates, but because the
# needed supplies are buried under many other crates, the crates need to be
# rearranged.

# The ship has a giant cargo crane capable of moving crates between stacks. To
# ensure none of the crates get crushed or fall over, the crane operator will
# rearrange them in a series of carefully-planned steps. After the crates are
# rearranged, the desired crates will be at the top of each stack.

# The Elves don't want to interrupt the crane operator during this delicate
# procedure, but they forgot to ask her which crate will end up where, and they
# want to be ready to unload them as soon as possible so they can embark.

# The Elves just need to know which crate will end up on top of each stack; in
# this example, the top crates are C in stack 1, M in stack 2, and Z in stack 3,
# so you should combine these together and give the Elves the message CMZ.

# After the rearrangement procedure completes, what crate ends up on top of each
# stack?

crates = File.read("crates.txt").split.map(&:chars).unshift([])

File.open("./instructions.txt", "r") do |f|
  f.each_line do |line|
    res = /move (\d+) from (\d+) to (\d+)/.match(line).captures
    count, start, destination = res.map(&:to_i)
    count.times do |i|
      crates[destination].unshift(crates[start].shift)
    end
  end
end

print crates.map(&:shift).join
