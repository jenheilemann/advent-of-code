# --- Part Two ---

# Your calculation isn't quite right. It looks like some of the digits are
# actually spelled out with letters: one, two, three, four, five, six, seven,
# eight, and nine also count as valid "digits".

# Equipped with this new information, you now need to find the real first and
# last digit on each line.

# What is the sum of all of the calibration values?

sum = 0
rx = /(one|two|three|four|five|six|seven|eight|nine|\d)/

def extract_num val
  dict = {
    "one" => "1", "two" => "2", "three" => "3", "four" => "4", "five" => "5",
    "six" => "6", "seven" => "7", "eight" => "8", "nine" => "9",
  }

  return val if val.match /\d/
  dict[val]
end

File.open("./input.txt", "r") do |f|
  f.each_line do |line|
    all_numbers = line.scan(rx).flatten
    sum += (extract_num(all_numbers.first) + extract_num(all_numbers.last)).to_i
  end
end

puts sum
