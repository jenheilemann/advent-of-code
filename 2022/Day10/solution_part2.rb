# --- Part Two ---

# It seems like the X register controls the horizontal position of a sprite.
# Specifically, the sprite is 3 pixels wide, and the X register sets the
# horizontal position of the middle of that sprite. (In this system, there is no
# such thing as "vertical position": if the sprite's horizontal position puts
# its pixels where the CRT is currently drawing, then those pixels will be
# drawn.)

# You count the pixels on the CRT: 40 wide and 6 high. This CRT screen draws the
# top row of pixels left-to-right, then the row below that, and so on. The
# left-most pixel in each row is in position 0, and the right-most pixel in each
# row is in position 39.

# Like the CPU, the CRT is tied closely to the clock circuit: the CRT draws a
# single pixel during each cycle. Representing each pixel of the screen as a #,
# here are the cycles during which the first and last pixel in each row are
# drawn:

# Cycle   1 -> ######################################## <- Cycle  40
# Cycle  41 -> ######################################## <- Cycle  80
# Cycle  81 -> ######################################## <- Cycle 120
# Cycle 121 -> ######################################## <- Cycle 160
# Cycle 161 -> ######################################## <- Cycle 200
# Cycle 201 -> ######################################## <- Cycle 240

# So, by carefully timing the CPU instructions and the CRT drawing operations,
# you should be able to determine whether the sprite is visible the instant each
# pixel is drawn. If the sprite is positioned such that one of its three pixels
# is the pixel currently being drawn, the screen produces a lit pixel (#);
# otherwise, the screen leaves the pixel dark (.).

# Render the image given by your program. What eight capital letters appear on
# your CRT?


class Ticker
  @@counter = 0
  SigCycles = 40, 80, 120, 160, 200, 240

  def self.tick
    @@counter += 1
  end

  def self.counter
    @@counter
  end

  def self.significant?
    SigCycles.include? @@counter
  end
end


class CPU
  def initialize
    @register = 1
  end

  def register; @register; end

  def tick
    Ticker.tick
    if (register..(register+2)).include? Ticker.counter % 40
      print "\#"
    else
      print "."
    end
    if Ticker.significant?
      print "\n"
    end
  end

  def addx(value)
    tick
    tick
    @register += value
  end

  def noop
    tick
  end
end

cpu = CPU.new

File.open("./input.txt", "r") do |f|
  f.each_line do |line|
    _, action, value = */(\w+)\s*(-*\d*)/.match(line)
    case action
    when 'addx'
      cpu.addx(value.to_i)
    when 'noop'
      cpu.noop
    end
  end
end

