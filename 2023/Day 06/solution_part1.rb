# --- Day 6: Wait For It ---

# The organizer explains that it's not really a traditional race - instead, you
# will get a fixed amount of time during which your boat has to travel as far as
# it can, and you win if your boat goes the farthest.

# As part of signing up, you get a sheet of paper (your puzzle input) that lists
# the time allowed for each race and also the best distance ever recorded in
# that race. To guarantee you win the grand prize, you need to make sure you go
# farther in each race than the current record holder.

# The organizer brings you over to the area where the boat races are held. The
# boats are much smaller than you expected - they're actually toy boats, each
# with a big button on top. Holding down the button charges the boat, and
# releasing the button allows the boat to move. Boats move faster if their
# button was held longer, but time spent holding the button counts against the
# total race time. You can only hold the button at the start of the race, and
# boats don't move until the button is released.

# To see how much margin of error you have, determine the number of ways you can
# beat the record in each race.

# Determine the number of ways you could beat the record in each race. What do
# you get if you multiply these numbers together?


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
times, distances = input.map { |substr| substr.split.drop(1).map(&:to_i) }

puts "times: #{times}, distances: #{distances}"

results = []
times.each_with_index do |time, i|
  results << calc_winning_options(time, distances[i])
end
puts "results: #{results}  ****   #{results.inject(1, &:*)}"
