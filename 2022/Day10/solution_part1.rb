# --- Day 10: Cathode-Ray Tube ---

# You avoid the ropes, plunge into the river, and swim to shore.

# The Elves yell something about meeting back up with them upriver, but the
# river is too loud to tell exactly what they're saying. They finish crossing
# the bridge and disappear from view.

# Situations like this must be why the Elves prioritized getting the
# communication system on your handheld device working. You pull it out of your
# pack, but the amount of water slowly draining from a big crack in its screen
# tells you it probably won't be of much immediate use.

# Unless, that is, you can design a replacement for the device's video system!
# It seems to be some kind of cathode-ray tube screen and simple CPU that are
# both driven by a precise clock circuit. The clock circuit ticks at a constant
# rate; each tick is called a cycle.

# Start by figuring out the signal being sent by the CPU. The CPU has a single
# register, X, which starts with the value 1. It supports only two instructions:

#     addx V    takes two cycles to complete. After two cycles, the X register
#               is increased by the value V. (V can be negative.)
#     noop      takes one cycle to complete. It has no other effect.

# Maybe you can learn something by looking at the value of the X register
# throughout execution. For now, consider the signal strength (the cycle number
# multiplied by the value of the X register) during the 20th cycle and every 40
# cycles after that (that is, during the 20th, 60th, 100th, 140th, 180th, and
# 220th cycles).

# Find the signal strength during the 20th, 60th, 100th, 140th, 180th, and 220th
# cycles. What is the sum of these six signal strengths?

class Ticker
  @@counter = 0
  SigCycles = 20, 60, 100, 140, 180, 220

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
    @cycles_of_interest = []
  end

  def cycles_of_interest; @cycles_of_interest; end
  def register; @register; end

  def tick
    Ticker.tick
    if Ticker.significant?
      @cycles_of_interest << @register * Ticker.counter
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

print cpu.cycles_of_interest, "\n"
puts cpu.cycles_of_interest.sum
