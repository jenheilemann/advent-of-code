# --- Day 21: Step Counter ---
# --- Part Two ---

# The Elf seems confused by your answer until he realizes his mistake: he was
# reading from a list of his favorite numbers that are both perfect squares and
# perfect cubes, not his step counter.

# The actual number of steps he needs to get today is exactly 26501365.

# He also points out that the garden plots and rocks are set up so that the map
# repeats infinitely in every direction.

# The input is just a tiny slice of the inexplicably-infinite farm layout;
# garden plots and rocks repeat as far as you can see. The Elf still starts on
# the one middle tile marked S, though - every other repeated S is replaced with
# a normal garden plot (.).

# However, the step count the Elf needs is much larger! Starting from the garden
# plot marked S on your infinite map, how many garden plots could the Elf reach
# in exactly 26501365 steps?

# ----------------------------------------

# notes: unfortunately, the test examples don't work for some of these
# assumptions. The full input has peculiar properties, in that there are
# straight clear lines from the center to each edge, and along the edges. This
# allows for fully traversing the width/height of a square in map.width steps or
# less (depending on where you start). You always either start in the center of
# a side, or at a corner. The edges of the explored area at the end of
# 26_501_365 intersect exactly in the center of the edges of the grids because
# of the nature of 26_501_365 mod map.width. Go look at the cheaty link, doofus.

class Main
  class << self
    # blatently stealing this from villuna:
    # https://github.com/villuna/aoc23/wiki/A-Geometric-solution-to-advent-of-code-2023,-day-21
    def run!(input, steps = 26501365)
      map = Map.from_input input.strip

      # assumption: the map is a square
      raise unless map.width == map.height

      start = Vector[*map.index("S")]
      # assumption: the starting point is in the exact center of the square
      # (and the square has odd-sized height + width)
      raise unless start[0] == start[1] && start[1] == map.width/2

      visited = identify_steps(map, start)

      # part 1
      # visited.filter{|k,v| k.even? && k <= 64 }.values.flatten.length

      # This is 202300 but we write it out to show the process
      n = ((steps - (map.width / 2)) / map.width)
      # assumption: steps gets us to exactly some multiple of the map size minus
      # half the map size (for the starting point in the center)
      raise unless n == 202300

      even_corners = n*visited.filter{|k,v| k.even? && k > 65 }.values.flatten.length
      odd_corners  = (n+1)*visited.filter{|k,v| k.odd? && k > 65 }.values.flatten.length


      even = n**2 * visited.filter{|k,v| k.even? }.values.flatten.length
      odd = (n+1)**2 * visited.filter{|k,v| k.odd? }.values.flatten.length

      even + odd - odd_corners + even_corners
    end

    def identify_steps(map, start)
      locations = {}
      dirs = [Map::UP, Map::DOWN, Map::LEFT, Map::RIGHT]
      queue = [[start,0]]

      while queue.length > 0
        this, dist = *queue.shift
        next unless locations[this].nil?
        locations[this] = dist
        dirs.each do |dir|
          new_loc = dir+this
          if locations[new_loc].nil? && map.passible?(new_loc)
            queue << [new_loc, dist+1]
          end
        end
      end

      locations.group_by {|k,v| v}.map{|k,v| [k, v.map(&:first)]}.to_h
    end
  end
end

class Map
  def passible?(vec)
    return false if outside_bounds? vec
    return false if self[*vec] == '#'
    true
  end
end
