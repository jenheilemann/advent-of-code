# --- Part Two ---

# The missing part wasn't the only issue - one of the gears in the engine is
# wrong. A gear is any * symbol that is adjacent to exactly two part numbers.
# Its gear ratio is the result of multiplying those two numbers together.

# This time, you need to find the gear ratio of every gear and add them all up
# so that the engineer can figure out which gear needs to be replaced.

# What is the sum of all of the gear ratios in your engine schematic?


require 'matrix'

input = File.read("input.txt").split.map(&:chars)
HEIGHT = input.length
WIDTH = input.first.length
puts "HEIGHT #{HEIGHT}, WIDTH #{WIDTH}"

Cell = Struct.new(:x, :y, :value, :visited, keyword_init: true) do
  def is_gear?
    value.match? /\*/
  end

  def is_number?
    value.match? /\d/
  end

  def on_edge?
    0 == y || y >= (WIDTH-1)
  end

  def identify_gears(schematic)
    puts "starting at:" + self.to_s
    dirs = [
      [x-1, y-1], [x-1, y], [x-1, y+1],
      [x,   y-1],           [x,   y+1],
      [x+1, y-1], [x+1, y], [x+1, y+1]
    ]
    dirs.filter! {|d| schematic[*d].is_number? }
    numbers = dirs.map{ |d| schematic[*d].find_complete_num!(schematic) }
                  .filter { |n| n != 0 }
    puts numbers.join(",")
    return numbers.first * numbers.last if numbers.length == 2
    0
  end

  def find_complete_num!(map)
    return 0 if !is_number? || visited
    puts self
    self.visited = true

    num = ''
    num += map[x, y-1].visit_left!(map) if y != 0
    num += value
    num += map[x, y+1].visit_right!(map) if y < WIDTH-1

    num.to_i
  end

  def visit_left!(map)
    return '' if !is_number? || visited
    puts "to the left: " + self.to_s
    self.visited = true
    return value if on_edge?

    map[x, y-1].visit_left!(map) + value
  end

  def visit_right!(map)
    return '' if !is_number? || visited
    puts "to the right: " + self.to_s
    self.visited = true
    return value if on_edge?

    value + map[x,y+1].visit_right!(map)
  end
end

schematic = Matrix.build(HEIGHT, WIDTH) do |x, y|
  Cell.new(x: x, y: y, value: input[x][y])
end

sum = 0
schematic.each do |cell|
  if cell.is_gear?
    sum += cell.identify_gears(schematic)
  end
end

puts sum
