# --- Day 1: Trebuchet?! ---

# The newly-improved calibration document consists of lines of text; each line
# originally contained a specific calibration value that the Elves now need to
# recover. On each line, the calibration value can be found by combining the
# first digit and the last digit (in that order) to form a single two-digit
# number.

# Consider your entire calibration document. What is the sum of all of the
# calibration values?

sum = 0
start_rx = /^\D*(\d)/
end_rx = /(\d)\D*$/

File.open("./input.txt", "r") do |f|
  f.each_line do |line|
    num = ""
    num += line.match(start_rx)[1]
    num += line.match(end_rx)[1]
    sum += num.to_i
  end
end

puts sum
