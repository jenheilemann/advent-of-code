# --- Part Two ---
# The Elf finishes helping with the tent and sneaks back over to you. "Anyway,
# the second column says how the round needs to end:
#   X means you need to lose,
#   Y means you need to end the round in a draw,
#   Z means you need to win.
# Good luck!"



scores = {
  "A X" => (0 + 3),
  "B X" => (0 + 1),
  "C X" => (0 + 2),
  "A Y" => (3 + 1),
  "B Y" => (3 + 2),
  "C Y" => (3 + 3),
  "A Z" => (6 + 2),
  "B Z" => (6 + 3),
  "C Z" => (6 + 1),
}
total = 0

File.open("./input.txt", "r") do |f|
  f.each_line do |line|
    total += scores[line.strip]
  end
end

puts total
