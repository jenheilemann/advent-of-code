# --- Day 2: Cube Conundrum ---

# You play several games and record the information from each game (your puzzle
# input). Each game is listed with its ID number (like the 11 in Game 11: ...)
# followed by a semicolon-separated list of subsets of cubes that were revealed
# from the bag (like 3 red, 5 green, 4 blue).

# Determine which games would have been possible if the bag had been loaded with
# only 12 red cubes, 13 green cubes, and 14 blue cubes. What is the sum of the
# IDs of those games?



def get_game_num line
  rgx = /Game (\d*):/
  return line.match(rgx)[1].to_i
end

def is_game_valid? line
  rules = { "red" => 12, "green" => 13, "blue" => 14 }
  rounds = line.split(";")
  rounds.each do |round|
    cubes = round.split(",")
    cubes.each do |set|
      matches = set.match /(\d+) (red|green|blue)/
      return false if matches[1].to_i > rules[matches[2]]
    end
  end
  return true
end

sum = 0
File.open("./input.txt", "r") do |f|
  f.each_line do |line|
    if is_game_valid? line
      sum += get_game_num(line)
    end
  end
end

puts sum
