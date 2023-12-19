# --- Day 8: Treetop Tree House ---

# The expedition comes across a peculiar patch of tall trees all planted
# carefully in a grid. The Elves explain that a previous expedition planted
# these trees as a reforestation effort. Now, they're curious if this would be a
# good location for a tree house.

# First, determine whether there is enough tree cover here to keep a tree house
# hidden. To do this, you need to count the number of trees that are visible
# from outside the grid when looking directly along a row or column.

# The Elves have already launched a quadcopter to generate a map with the height
# of each tree (your puzzle input).

# Each tree is represented as a single digit whose value is its height, where 0
# is the shortest and 9 is the tallest.

# A tree is visible if all of the other trees between it and an edge of the grid
# are shorter than it. Only consider trees in the same row or column; that is,
# only look up, down, left, or right from any given tree.

# Consider your map; how many trees are visible from outside the grid?
require 'matrix'

input = File.read("input.txt").split.map(&:chars)
HEIGHT = input.length
WIDTH = input.first.length
puts "HEIGHT #{HEIGHT}, WIDTH #{WIDTH}"


Tree = Struct.new(:x, :y, :height, :visible, keyword_init: true) do
  def determine_visible!(forest)
    self.visible = calc_visible(forest)
  end

  def on_edge?
    return true if x == 0 || y == 0
    return true if x == (WIDTH-1) || y == (HEIGHT-1)

    false
  end

  def calc_visible(forest)
    return true if on_edge?
    return true if up_clear?(forest, x - 1)
    return true if down_clear?(forest, x + 1)
    return true if left_clear?(forest, y - 1)
    return true if right_clear?(forest, y + 1)
    return false
  end

  def up_clear?(forest, i)
    return true if i == -1
    return up_clear?(forest, i-1) if forest[i, y].height < self.height
    return false
  end

  def down_clear?(forest, i)
    return true if i == HEIGHT
    return down_clear?(forest, i+1) if forest[i, y].height < self.height
    return false
  end

  def left_clear?(forest, i)
    return true if i == -1
    return left_clear?(forest, i-1) if forest[x, i].height < self.height
    return false
  end

  def right_clear?(forest, i)
    return true if i == WIDTH
    return right_clear?(forest, i+1) if forest[x, i].height < self.height
    return false
  end
end

forest = Matrix.build(HEIGHT, WIDTH) do |x, y|
  Tree.new(x: x, y: y, height: input[x][y])
end

forest.each do |tree|
  tree.determine_visible!(forest)
end

list = forest.to_a.flatten
print list.select(&:visible).length
