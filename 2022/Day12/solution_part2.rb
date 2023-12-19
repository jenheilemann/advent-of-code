# --- Part Two ---

# As you walk up the hill, you suspect that the Elves will want to turn this
# into a hiking trail. The beginning isn't very scenic, though; perhaps you can
# find a better starting point.

# To maximize exercise while hiking, the trail should start as low as possible:
# elevation a. The goal is still the square marked E. However, the trail should
# still be direct, taking the fewest steps to reach its goal. So, you'll need to
# find the shortest path from any square at elevation a to the square marked E.

# What is the fewest steps required to move starting from any square with
# elevation a to the location that should get the best signal?


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

  def is_end?; elevation == "S" || elevation == "a" ; end
  def unvisited?; !self.visited; end

  def visit!(dist)
    self.visited = true
    self.distance = dist if dist < self.distance
  end

  def passable?(other)
    return true if (elevation == "b") && other.is_end?
    return false if other.is_end?
    other.elevation.next == elevation || other.elevation >= elevation
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
start = map[ *map.index {|l| l.elevation == "E" } ]
start.visit!(0)
start.elevation = "z"

print start, "\n"
walker = PathWalker.new(start: start, map: map)
print walker.walk!

