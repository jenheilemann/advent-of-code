# --- Day 17: Clumsy Crucible ---

# The crucibles are top-heavy and pushed by hand. Unfortunately, the crucibles
# become very difficult to steer at high speeds, and so it can be hard to go in
# a straight line for very long.

# To get Desert Island the machine parts it needs as soon as possible, you'll
# need to find the best way to get the crucible from the lava pool to the
# machine parts factory. To do this, you need to minimize heat loss while
# choosing a route that doesn't require the crucible to go in a straight line
# for too long.

# Fortunately, the Elves here have a map (your puzzle input) that uses traffic
# patterns, ambient temperature, and hundreds of other parameters to calculate
# exactly how much heat loss can be expected for a crucible entering any
# particular city block.

# Each city block is marked by a single digit that represents the amount of heat
# loss if the crucible enters that block. The starting point, the lava pool, is
# the top-left city block; the destination, the machine parts factory, is the
# bottom-right city block. (Because you already start in the top-left block, you
# don't incur that block's heat loss unless you leave that block and then return
# to it.)

# Because it is difficult to keep the top-heavy crucible going in a straight
# line for very long, it can move at most three blocks in a single direction
# before it must turn 90 degrees left or right. The crucible also can't reverse
# direction; after entering each city block, it may only turn left, continue
# straight, or turn right.

# Directing the crucible from the lava pool to the machine parts factory, but
# not moving more than three consecutive blocks in the same direction, what is
# the least heat loss it can incur?
require 'set'

EXAMPLE0 = <<~'EXAMPLE'
          11199
          12199
          99199
          99131
          99111
          EXAMPLE

EXAMPLEB = <<~'EXAMPLE'
          122
          122
          111
          EXAMPLE

EXAMPLE1 = <<~'EXAMPLE'
          2413432311323
          3215453535623
          3255245654254
          3446585845452
          4546657867536
          1438598798454
          4457876987766
          3637877979653
          4654967986887
          4564679986453
          1224686865563
          2546548887735
          4322674655533
          EXAMPLE

class TestMain < Minitest::Test
  def test_run
    assert_equal(4, Main.run!(EXAMPLEB))
    assert_equal(9, Main.run!(EXAMPLE0))
    assert_equal(102, Main.run!(EXAMPLE1))
  end
end

class Main
  DIRS = [[0,1], [1,0], [0,-1], [-1,0]]
  class << self
    def run!(input)
      map = Map.from_input(input) {|s| s.to_i }
      finish = dijkstra(map)
      puts "#{[finish]}"
      finish
    end

    def dijkstra(map)
      min_dist = 1
      max_dist = 3
      # cost, x, y, disallowed_direction
      q = HeapQ.new
      q.heapq_min_heapify!
      q.heapq_min_enqueue [0, 0, 0, -1]
      seen = Set.new
      costs = {}

      until q.empty?
        cost, x, y, dd = *q.heapq_min_deque()
        if x == map.width-1 && y == map.height-1
          return cost
        end

        if seen.include? [x,y,dd]
          next
        end
        seen << [x, y, dd]

        (0..3).each do |direction|
          costincrease = 0
          if direction == dd || (direction + 2)%4 == dd
            next
          end
          (0..max_dist).each do |distance|
            xx = x + DIRS[direction][0] * distance
            yy = y + DIRS[direction][1] * distance

            next if map.outside_bounds?(xx, yy)
            next if distance < min_dist

            costincrease += map[xx,yy]
            nc = cost + costincrease
            if !costs[[xx,yy,direction]].nil? && costs[[xx,yy,direction]] <= nc
              next
            end
            costs[[xx,yy,direction]] = nc
            q.heapq_min_enqueue([nc, xx, yy, direction])
          end
        end
      end
    end
  end
end

