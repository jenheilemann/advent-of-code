# --- Day 12: Hill Climbing Algorithm ---

# You try contacting the Elves using your handheld device, but the river you're
# following must be too low to get a decent signal.

# You ask the device for a heightmap of the surrounding area (your puzzle
# input). The heightmap shows the local area from above broken into a grid; the
# elevation of each square of the grid is given by a single lowercase letter,
# where a is the lowest elevation, b is the next-lowest, and so on up to the
# highest elevation, z.

# Also included on the heightmap are marks for your current position (S) and the
# location that should get the best signal (E). Your current position (S) has
# elevation a, and the location that should get the best signal (E) has
# elevation z.

# You'd like to reach E, but to save energy, you should do it in as few steps as
# possible. During each step, you can move exactly one square up, down, left, or
# right. To avoid needing to get out your climbing gear, the elevation of the
# destination square can be at most one higher than the elevation of your
# current square; that is, if your current elevation is m, you could step to
# elevation n, but not to elevation o. (This also means that the elevation of
# the destination square can be much lower than the elevation of your current
# square.)

# What is the fewest steps required to move from your current position to the
# location that should get the best signal?

require 'matrix'


Location = Struct.new(:x, :y, :elevation, :visited, :distance, keyword_init: true) do
  def initialize(x:, y:, elevation:, visited: false, distance: Float::INFINITY)
    super
  end

  def U; [self.y-1, self.x]; end
  def D; [self.y+1, self.x]; end
  def L; [self.y, self.x-1]; end
  def R; [self.y, self.x+1]; end

  def neighbors(map)
    neighbors = []

    neighbors << self.U if self.U.all? {|v| v >= 0 }
    neighbors << self.D
    neighbors << self.L if self.L.all? {|v| v >= 0 }
    neighbors << self.R
    neighbors.map{|n| map[*n]}.compact
  end

  def to_s; "<Location #{x},#{y} '#{elevation}' #{visited} #{distance}>"; end

  def is_end?; elevation == "E"; end
  def unvisited?; !self.visited; end

  def visit!(dist)
    self.visited = true
    self.distance = dist if dist < self.distance
  end

  def passable?(other)
    return true if (elevation == "y" || elevation == "z") && other.is_end?
    return false if other.is_end?
    other.elevation <= elevation.next
  end
end

PathWalker = Struct.new(:start, :map, keyword_init: true) do
  def walk!
    to_visit = [start]

    while to_visit.length > 0
      loc = to_visit.shift

      return loc if loc.is_end?

      neighbors = loc.neighbors(map).filter {|n| n.unvisited? && loc.passable?(n) }
      neighbors.each {|n| n.visit!(loc.distance + 1) }
      to_visit += neighbors
    end
  end
end

locationData = File.read("input.txt").split.map(&:chars)
locations = []
locationData.map.with_index do |row, row_i|
  locations << row.map.with_index do |elev, col|
    Location.new(x: col, y: row_i, elevation: elev)
  end
end

map = Matrix[*locations]
start = map[ *map.index {|l| l.elevation == "S" } ]
start.visit!(0)
start.elevation = "a"

print start, "\n"
walker = PathWalker.new(start: start, map: map)
print walker.walk!

