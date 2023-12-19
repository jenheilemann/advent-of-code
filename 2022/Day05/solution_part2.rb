# --- Part Two ---

# As you watch the crane operator expertly rearrange the crates, you notice the
# process isn't following your prediction.

# Some mud was covering the writing on the side of the crane, and you quickly wipe
# it away. The crane isn't a CrateMover 9000 - it's a CrateMover 9001.

# The CrateMover 9001 is notable for many new and exciting features: air
# conditioning, leather seats, an extra cup holder, and the ability to pick up and
# move multiple crates at once.

# Before the rearrangement process finishes, update your simulation so that the
# Elves know where they should stand to be ready to unload the final supplies.
# After the rearrangement procedure completes, what crate ends up on top of each
# stack?


crates = File.read("crates.txt").split.map(&:chars).unshift([])

File.open("./instructions.txt", "r") do |f|
  f.each_line do |line|
    res = /move (\d+) from (\d+) to (\d+)/.match(line)
    count, start, destination = res.captures.map(&:to_i)
    crates[destination].unshift(*crates[start].shift(count))
  end
end

print crates.map(&:shift).join
