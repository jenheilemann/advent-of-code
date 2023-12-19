# --- Part Two ---

# Content with the amount of tree cover available, the Elves just need to know
# the best spot to build their tree house: they would like to be able to see a
# lot of trees.

# To measure the viewing distance from a given tree, look up, down, left, and
# right from that tree; stop if you reach an edge or at the first tree that is
# the same height or taller than the tree under consideration. (If a tree is
# right on the edge, at least one of its viewing distances will be zero.)

# The Elves don't care about distant trees taller than those found by the rules
# above; the proposed tree house has large eaves to keep it dry, so they
# wouldn't be able to see higher than the tree house anyway.

# A tree's scenic score is found by multiplying together its viewing distance in
# each of the four directions.

# Consider each tree on your map. What is the highest scenic score possible for
# any tree?

require 'matrix'

input = File.read("input.txt").split.map(&:chars)
HEIGHT = input.length
WIDTH = input.first.length
puts "HEIGHT #{HEIGHT}, WIDTH #{WIDTH}"


Tree = Struct.new(:x, :y, :height, :scenic_score, keyword_init: true) do
  def determine_scenic_score!(forest)
    self.scenic_score = calc_score(forest)
  end

  def calc_score(forest)
    return 0 if on_edge?
    up(forest,x-1) * down(forest,x+1) * left(forest,y-1) * right(forest,y+1)
  end

  def on_edge?
    return true if x == 0 || y == 0
    return true if x == (WIDTH-1) || y == (HEIGHT-1)

    false
  end

  def up(forest,i, score=0)
    return score if i == -1
    return up(forest, i-1, score+1) if forest[i, y].height < self.height
    return score + 1
  end

  def down(forest, i, score=0)
    return score if i == HEIGHT
    return down(forest, i+1, score+1) if forest[i, y].height < self.height
    return score + 1
  end

  def left(forest, i, score=0)
    return score if i == -1
    return left(forest, i-1, score+1) if forest[x, i].height < self.height
    return score + 1
  end

  def right(forest, i, score=0)
    return score if i == WIDTH
    return right(forest, i+1, score+1) if forest[x, i].height < self.height
    return score + 1
  end
end

forest = Matrix.build(HEIGHT, WIDTH) do |x, y|
  Tree.new(x: x, y: y, height: input[x][y])
end

forest.each do |tree|
  tree.determine_scenic_score!(forest)
end

list = forest.to_a.flatten
print list.max_by(&:scenic_score)
