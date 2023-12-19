# --- Day 6: Wait For It ---
# -- Part Two ---

# As the race is about to start, you realize the piece of paper with race times
# and record distances you got earlier actually just has very bad kerning.
# There's really only one race - ignore the spaces between the numbers on each
# line.

# So, the example from before:

# Time:      7  15   30
# Distance:  9  40  200

# ...now instead means this:

# Time:      71530
# Distance:  940200

# Now, you have to figure out how many ways there are to win this single race.
# In this example, the race lasts for 71530 milliseconds and the record distance
# you need to beat is 940200 millimeters. You could hold the button anywhere
# from 14 to 71516 milliseconds and beat the record, a total of 71503 ways!

# How many ways can you beat the record in this one much longer race?

def calc_winning_options time, distance
  calc_max(time, distance) - calc_min(time, distance) + 1
end

def calc_max(time, distance)
  puts "calculating max for #{time}, #{distance}"
  -(-time..0).find do |v|
    d = distance_traveled(time, -v)
    d > distance
  end
end

def calc_min(time, distance)
  puts "calculating min for #{time}, #{distance}"
  (0..time).find do |v|
    d = distance_traveled(time, v)
    d > distance
  end
end

def distance_traveled(total_time, button_held)
  (total_time - button_held)*button_held
end


input = File.read("input.txt").split("\n")
times, distances = input.map { |substr| substr.split.drop(1).join.to_i }

puts "times: #{times}, distances: #{distances}"

results = calc_winning_options(times, distances)
puts "results: #{results}"
