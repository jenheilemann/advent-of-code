# --- Day 23: A Long Walk ---
# --- Part Two ---

# Now, treat all slopes as if they were normal paths (.). You still want to make
# sure you have the most scenic hike possible, so continue to ensure that you
# never step onto the same tile twice. What is the longest hike you can take?

# Find the longest hike you can take through the surprisingly dry hiking trails
# listed on your map. How many steps long is the longest hike?

require 'set'

EXAMPLE1 = <<~'EXAMPLE'
#.#####################
#.......#########...###
#######.#########.#.###
###.....#.>.>.###.#.###
###v#####.#v#.###.#.###
###.>...#.#.#.....#...#
###v###.#.#.#########.#
###...#.#.#.......#...#
#####.#.#.#######.#.###
#.....#.#.#.......#...#
#.#####.#.#.#########v#
#.#...#...#...###...>.#
#.#.#v#######v###.###v#
#...#.>.#...>.>.#.###.#
#####v#.#.###v#.#.###.#
#.....#...#...#.#.#...#
#.#########.###.#.#.###
#...###...#...#...#.###
###.###.#.###v#####v###
#...#...#.#.>.>.#.>.###
#.###.###.#.###.#.#v###
#.....###...###...#...#
#####################.#
          EXAMPLE

# This probably needs... something. Runs in ~12 minutes on my machine.

class TestMain < Minitest::Test
  def test_run
    assert_equal(154, Main.run!(EXAMPLE1))
  end
end

class Main
  class << self
    def run!(input)
      map = Map.from_input(input)

      start = Vector[1,0]
      finish = Vector[map.width-2, map.height-1]

      nodes = [[start, Map::DOWN]]
      edges = Hash.new{|hsh,k| hsh[k] = {}}
      visited = []
      previous = nil

      until nodes.empty?
        current_node, initial_direction = nodes.shift
        previous = current_node
        step = current_node + initial_direction
        visited << current_node
        puts "current_node: #{current_node}, initial_direction: #{initial_direction}, step: #{step}"

        dist = 0
        while true
          dist += 1
          if visited.include?(step) || step == finish
            if edges[current_node][step].nil? || edges[current_node][step] < dist
              edges[current_node][step] = dist
              edges[step][current_node] = dist
            end
            break
          end

          poss_dirs = Map::DIRECTIONS.filter{|d| map.passible?(d+step) && (d+step) != previous }
          if poss_dirs.length > 1
            # it's an intersection
            edges[current_node][step] = dist
            edges[step][current_node] = dist
            poss_dirs.each {|dir| nodes << [step, dir] unless nodes.include?([step, dir]) }
            break
          end
          if poss_dirs.empty?
            #it's a dead end
            break
          end
          previous = step
          step = poss_dirs[0] + step
        end
      end
      edges.each{|k,v| puts "#{k} ==> #{v}"}

      paths = [[[start], 0]]

      successful = 0
      until paths.empty?
        path, cost = paths.shift
        if path.last == finish
          if cost > successful
            successful = cost
            puts "Success!: #{successful}"
          end
          next
        end

        edges[path.last].each do |step, dist|
          if !path[..-2].include?(step)
            new_path = path.dup << step
            paths << [new_path, cost+dist]
          end
        end
      end

      successful
    end
  end
end

class Map
  SLOPES = {
    UP    => '^',
    DOWN  => 'v',
    LEFT  => '<',
    RIGHT => '>',
  }

  def passible?(loc)
    return false if outside_bounds?(loc)
    return false if self[*loc] == '#'
    true
  end
end
