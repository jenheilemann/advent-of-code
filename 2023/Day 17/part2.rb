# --- Day 17: Clumsy Crucible ---
# --- Part Two ---

# Once an ultra crucible starts moving in a direction, it needs to move a
# minimum of four blocks in that direction before it can turn (or even before it
# can stop at the end). However, it will eventually start to get wobbly: an
# ultra crucible can move a maximum of ten consecutive blocks without turning.

# Directing the ultra crucible from the lava pool to the machine parts factory,
# what is the least heat loss it can incur?

require 'set'

EXAMPLE0 = <<~'EXAMPLE'
          111111111111
          999999999991
          999999999991
          999999999991
          999999999991
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
    assert_equal(71, Main.run!(EXAMPLE0))
    assert_equal(94, Main.run!(EXAMPLE1))
  end
end

class Main
  DIRS = [[0,1], [1,0], [0,-1], [-1,0]]
  class << self
    def run!(input)
      map = Map.from_input(input) {|s| s.to_i }
      finish = dijkstra(map)
      finish
    end

    def dijkstra(map)
      min_dist = 4
      max_dist = 10
      q = HeapQ.new
      q.heapq_min_heapify!
      # cost, x, y, disallowed_direction
      q.heapq_min_enqueue [0, 0, 0, -1]
      seen = Set.new
      costs = {}

      until q.empty?
        puts "Seen length: #{seen.length}"
        cost, x, y, dd = *q.heapq_min_deque()
        return cost if x == map.width-1 && y == map.height-1

        next if seen.include? [x,y,dd]
        seen << [x, y, dd]

        (0..3).each do |direction|
          costincrease = 0
          next if direction == dd || (direction + 2)%4 == dd
          (1..max_dist).each do |distance|
            xx = x + DIRS[direction][0] * distance
            yy = y + DIRS[direction][1] * distance
            next if map.outside_bounds?(xx, yy)

            costincrease += map[xx,yy]
            next if distance < min_dist
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
