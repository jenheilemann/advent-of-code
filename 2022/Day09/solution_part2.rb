# --- Part Two: longer ropes ---

# Rather than two knots, you now must simulate a rope consisting of ten knots.
# One knot is still the head of the rope and moves according to the series of
# motions. Each knot further down the rope follows the knot in front of it using
# the same rules as before.

# Now, you need to keep track of the positions the new tail, 9, visits. In this
# example, the tail never moves, and so it only visits 1 position. However, be
# careful: more types of motion are possible than before, so you might want to
# visually compare your simulated rope to the one above.

# Simulate your complete series of motions on a larger rope with ten knots. How
# many positions does the tail of the rope visit at least once?

require 'set'

Location = Struct.new(:x, :y, keyword_init: true) do
  def U; Location.new(x: self.x, y: self.y+1); end
  def D; Location.new(x: self.x, y: self.y-1); end
  def L; Location.new(x: self.x-1, y: self.y); end
  def R; Location.new(x: self.x+1, y: self.y); end

  def x_range; Range.new(x-1, x+1); end
  def y_range; Range.new(y-1, y+1); end

  def move_to(other)
    return self if close?(other)

    diff_x, diff_y = diff(other)
    return self.U   if diff_x == 0 && diff_y > 0
    return self.D   if diff_x == 0 && diff_y < 0
    return self.R   if diff_x > 0 && diff_y == 0
    return self.L   if diff_x < 0 && diff_y == 0

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
end


rope = Array.new(10) { |i| Location.new(x: 0, y: 0) }
visited = Set.new()

File.open("./input.txt", "r") do |f|
  f.each_line do |line|
    _, direction, distance = */(\w) (\d+)/.match(line)
    distance.to_i.times do
      new_rope = []
      rope.each_with_index do |knot, idx|
        new_rope << rope[0].send(direction) && next if idx == 0
        new_rope << knot.move_to(new_rope[idx-1])
      end
      visited << new_rope[9]
      rope = new_rope
    end
  end
end

puts visited.length
