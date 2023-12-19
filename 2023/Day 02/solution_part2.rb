# --- Part Two ---

# As you continue your walk, the Elf poses a second question: in each game you
# played, what is the fewest number of cubes of each color that could have been
# in the bag to make the game possible?

# For each game, find the minimum set of cubes that must have been present. What
# is the sum of the power of these sets?


def get_min(color, line)
  rgx = /(\d*) #{color}/
  matches = line.scan(rgx).flatten!
  matches.map(&:to_i).max
end

def calc_power(line)
  get_min("red", line) * get_min("green", line) * get_min("blue", line)
end

sum = 0
File.open("./input.txt", "r") do |f|
  f.each_line do |line|
    sum += calc_power(line)
  end
end

puts sum
