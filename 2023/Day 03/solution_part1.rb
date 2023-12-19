# --- Day 3: Gear Ratios ---

# The engineer explains that an engine part seems to be missing from the engine,
# but nobody can figure out which one. If you can add up all the part numbers in
# the engine schematic, it should be easy to work out which part is missing.

# The engine schematic (your puzzle input) consists of a visual representation
# of the engine. There are lots of numbers and symbols you don't really
# understand, but apparently any number adjacent to a symbol, even diagonally,
# is a "part number" and should be included in your sum. (Periods (.) do not
# count as a symbol.)

# What is the sum of all of the part numbers in the engine schematic?

require 'matrix'

input = File.read("input.txt").split.map(&:chars)
HEIGHT = input.length
WIDTH = input.first.length
puts "HEIGHT #{HEIGHT}, WIDTH #{WIDTH}"

Cell = Struct.new(:x, :y, :value, :visited, keyword_init: true) do
  def is_symbol?
    value.match? /[^\d\.]/
  end

  def is_number?
    value.match? /\d/
  end

  def on_edge?
    0 == y || y >= (WIDTH-1)
  end

  def identify_part_numbers(schematic)
    puts "starting at:" + self.to_s
    dirs = [
      [x-1, y-1], [x-1, y], [x-1, y+1],
      [x,   y-1],           [x,   y+1],
      [x+1, y-1], [x+1, y], [x+1, y+1]
    ]
    dirs.filter! {|d| schematic[*d].is_number? }
    print dirs, "\n"
    numbers = dirs.map{ |d| schematic[*d].find_complete_num!(schematic) }
    puts numbers.join(",")
    numbers.sum
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
    puts "on_edge? #{on_edge?} x#{x} y#{y}"
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
  if cell.is_symbol?
    sum += cell.identify_part_numbers(schematic)
  end
end

puts sum
