# --- Part Two ---

# Your device's communication system is correctly detecting packets, but still
# isn't working. It looks like it also needs to look for messages.

# A start-of-message marker is just like a start-of-packet marker, except it
# consists of 14 distinct characters rather than 4.

# How many characters need to be processed before the first start-of-message
# marker is detected?


require "set"
datastream = File.read("input.txt").chars

datastream.length.times do |i|
  next if i < 13
  return print(i + 1) if Set.new(datastream[(i-13)..i]).length > 13
end
