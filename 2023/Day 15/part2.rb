# --- Day 15: Lens Library ---
# --- Part Two ---

# The book goes on to describe a series of 256 boxes numbered 0 through 255. The
# boxes are arranged in a line starting from the point where light enters the
# facility. The boxes have holes that allow light to pass from one box to the
# next all the way down the line.

# If the operation character is an equals sign (=), it will be followed by a
# number indicating the focal length of the lens that needs to go into the
# relevant box; be sure to use the label maker to mark the lens with the label
# given in the beginning of the step so you can find it later. There are two
# possible situations:

#    If there is already a lens in the box with the same label, replace the old
#      lens with the new lens: remove the old lens and put the new lens in its
#      place, not moving any other lenses in the box.
#    If there is not already a lens in the box with the same label, add the lens
#      to the box immediately behind any lenses already in the box. Don't move
#      any of the other lenses when you do this. If there aren't any lenses in
#      the box, the new lens goes all the way to the front of the box.

# If the operation character is a dash (-), go to the relevant box and remove
# the lens with the given label if it is present in the box. Then, move any
# remaining lenses as far forward in the box as they can go without changing
# their order, filling any space made by removing the indicated lens. (If no
# lens in that box has the given label, nothing happens.)

# To confirm that all of the lenses are installed correctly, add up the focusing
# power of all of the lenses. The focusing power of a single lens is the result
# of multiplying together:

#     One plus the box number of the lens in question.
#     The slot number of the lens within the box: 1 for the first lens, 2 for
#       the second lens, and so on.
#     The focal length of the lens.

# With the help of an over-enthusiastic reindeer in a hard hat, follow the
# initialization sequence. What is the focusing power of the resulting lens
# configuration?


EXAMPLE1 = "rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7"

class TestMain < Minitest::Test
  def test_run
    assert_equal(145, Main.run!(EXAMPLE1))
  end
end

class TestBoxManager < Minitest::Test
  def test_decode
    assert_equal 52, BoxManager.decode('HASH')
    assert_equal 30, BoxManager.decode('rn=1')
    assert_equal 47, BoxManager.decode('cm=2')
    assert_equal 14, BoxManager.decode('qp-')
    assert_equal 0, BoxManager.decode('rn')
  end

  def test_initialize
    assert_equal 256, BoxManager.new.boxes.length
    assert_kind_of Box, BoxManager.new.boxes[0]
    assert_kind_of Box, BoxManager.new.boxes[4]
    assert_kind_of Box, BoxManager.new.boxes[255]
    assert_nil BoxManager.new.boxes[256]
  end
end

class Main
  class << self
    def run!(input)
      boxes = BoxManager.new
      input.strip.split(',').each {|str| boxes.sort_lens(str) }
      boxes.calc_focusing_power
    end
  end
end

class BoxManager
  attr_reader :boxes
  def initialize
    @boxes = 256.times.map {|i| Box.new(i) }
  end

  def calc_focusing_power
    boxes.sum {|b| b.focusing_power }
  end

  def sort_lens(str)
    code = self.class.decode(str.match(/\w+/)[0])
    if str.include?('=') # 'code=4'
      boxes[code].add_lens(str)
    else # 'code-'
      boxes[code].remove_lens(str)
    end
  end

  def self.decode(str)
    str.chars.inject(0) {|sum, char|
      sum += char.ord
      sum *= 17
      sum % 256
    }
  end
end

class Box
  attr_reader :number
  attr_reader :lenses
  def initialize(number)
    @number = number
    @lenses = {}
  end

  def focusing_power
    (number + 1) * lenses.each_with_index.sum {|(_, focal_length), i| (i+1) * focal_length }
  end

  def add_lens(str)
    label, focal_length = str.split('=')
    lenses[label] = focal_length.to_i
  end

  def remove_lens(label)
    lenses.delete(label[..-2])
  end
end
