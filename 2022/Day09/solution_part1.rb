# --- Day 9: Rope Bridge ---

# Consider a rope with a knot at each end; these knots mark the head and the
# tail of the rope. If the head moves far enough away from the tail, the tail is
# pulled toward the head.

# Due to nebulous reasoning involving Planck lengths, you should be able to
# model the positions of the knots on a two-dimensional grid. Then, by following
# a hypothetical series of motions (your puzzle input) for the head, you can
# determine how the tail will move.

# Due to the aforementioned Planck lengths, the rope must be quite short; in
# fact, the head (H) and tail (T) must always be touching (diagonally adjacent
# and even overlapping both count as touching):

# ....  ....  ....
# .TH.  .H..  ....
# ....  ..T.  ..H. (H covers T)

# If the head is ever two steps directly up, down, left, or right from the tail,
# the tail must also move one step in that direction so it remains close enough.
# Otherwise, if the head and tail aren't touching and aren't in the same row or
# column, the tail always moves one step diagonally to keep up. You just need to
# work out where the tail goes as the head follows a series of motions. Assume
# the head and the tail both start at the same position, overlapping.

# After simulating the rope, you can count up all of the positions the tail
# visited at least once. How many positions does the tail of the rope visit at
# least once?

require 'set'

Location = Struct.new(:x, :y, keyword_init: true) do
  def U; Location.new(x: self.x, y: self.y+1); end
  def D; Location.new(x: self.x, y: self.y-1); end
  def L; Location.new(x: self.x-1, y: self.y); end
  def R; Location.new(x: self.x+1, y: self.y); end

  def x_range; Range.new(x-1, x+1); end
  def y_range; Range.new(y-1, y+1); end

  def move_to(other, direction)
    return self if close?(other)
    return send(direction) if !diagonal_to?(other)

    diff_x, diff_y = diff(other)
    return self.U.R if diff_x > 0 && diff_y > 0
    return self.D.R if diff_x > 0 && diff_y < 0
    return self.D.L if diff_x < 0 && diff_y < 0
    return self.U.L if diff_x < 0 && diff_y > 0
  end

  def diff(other)
    [other.x - x, other.y - y]
  end

  def close?(other)
    return true if x_range.cover?(other.x) && y_range.cover?(other.y)
    false
  end

  def diagonal_to?(other)
    return false if x == other.x || y == other.y
    true
  end
end


head = tail = Location.new(x: 0, y: 0)
visited = Set.new([tail])

File.open("./input.txt", "r") do |f|
  f.each_line do |line|
    _, direction, distance = */(\w) (\d+)/.match(line)
    distance.to_i.times do
      head = head.send(direction)
      tail = tail.move_to(head, direction)
      visited << tail
    end
  end
end

puts visited.length
