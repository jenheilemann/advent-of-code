# --- Day 20: Pulse Propagation ---

# There are several different types of modules:

# Flip-flop modules (prefix %) are either on or off; they are initially off. If
# a flip-flop module receives a high pulse, it is ignored and nothing happens.
# However, if a flip-flop module receives a low pulse, it flips between on and
# off. If it was off, it turns on and sends a high pulse. If it was on, it turns
# off and sends a low pulse.

# Conjunction modules (prefix &) remember the type of the most recent pulse
# received from each of their connected input modules; they initially default to
# remembering a low pulse for each input. When a pulse is received, the
# conjunction module first updates its memory for that input. Then, if it
# remembers high pulses for all inputs, it sends a low pulse; otherwise, it
# sends a high pulse.

# There is a single broadcast module (named broadcaster). When it receives a
# pulse, it sends the same pulse to all of its destination modules.

# Here at Desert Machine Headquarters, there is a module with a single button on
# it called, aptly, the button module. When you push the button, a single low
# pulse is sent directly to the broadcaster module.

# After pushing the button, you must wait until all pulses have been delivered
# and fully handled before pushing it again. Never push the button if modules
# are still processing pulses.

# Pulses are always processed in the order they are sent. So, if a pulse is sent
# to modules a, b, and c, and then module a processes its pulse and sends more
# pulses, the pulses sent to modules b and c would have to be handled first.

# The module configuration (your puzzle input) lists each module. The name of
# the module is preceded by a symbol identifying its type, if any. The name is
# then followed by an arrow and a list of its destination modules. For example:

# Consult your module configuration; determine the number of low pulses and high
# pulses that would be sent after pushing the button 1000 times, waiting for all
# pulses to be fully handled after each push of the button. What do you get if
# you multiply the total number of low pulses sent by the total number of high
# pulses sent?


EXAMPLE1 = <<~'EXAMPLE'
          broadcaster -> aa, bb, cc
          %aa -> bb
          %bb -> cc
          %cc -> in
          &in -> aa
          EXAMPLE

EXAMPLE2 = <<~'EXAMPLE'
          broadcaster -> aa
          %aa -> in, co
          &in -> bb
          %bb -> co
          &co -> output
          EXAMPLE

class TestMain < Minitest::Test
  def test_run
    assert_equal(32000000, Main.run!(EXAMPLE1))
    assert_equal(11687500, Main.run!(EXAMPLE2))
  end
end

class Main
  class << self
    def run!(input)
      broadcaster, modules = module_factory(input.strip.split("\n"))
      counts = {hi: 0, lo: 0}
      puts "Modules: "
      modules.each{|m| puts "#{m}"; puts " -- inputs: #{m[1].inputs}" if m[0] == 'in' }
      1000.times do |t|
        counts[:lo] += 1 # push the button!
        signals = [broadcaster.get_signal(:lo)]
        until signals.empty?
          current = signals.shift
          counts[current.strength] += current.targets.length
          current.targets.each do |target|
            next if modules[target].nil?
            signals << modules[target].process(current)
          end
        end
      end
      puts "counts: #{counts}"
      counts[:hi] * counts[:lo]
    end

    def module_factory(strs)
      modules = {}
      con_mods = []
      broadcaster = nil

      strs.each do |s|
        case s[0]
        when '%'
          modules[s[1..2]] = FlipFlopModule.from_input(s[1..])
        when '&'
          modules[s[1..2]] = ConjunctionModule.from_input(s[1..])
          con_mods << s[1..2]
        when 'b'
          broadcaster = BroadcastModule.from_input(s)
        else
          throw StandardError.new("one of the strings looks weird")
        end
      end

      con_mods.each do |con|
        modules[con].init_inputs(modules.filter{|k,v| v.targets.include?(con) }.keys)
      end
      [broadcaster, modules]
    end
  end
end

Signal = Struct.new(:strength, :targets, :source)

ComModule = Struct.new(:key, :targets, keyword_init: true) do
  class << self
    def from_input(str)
      n, t = str.strip.split(' -> ')
      t = t.split(', ')
      new(key: n, targets: t)
    end
  end

  def process(signal)
    get_signal(signal.strength)
  end

  def get_signal(strength)
    Signal.new(strength, targets, key)
  end
end

class FlipFlopModule < ComModule
  OFF = false
  ON = true

  attr_accessor :status
  def initialize(args)
    status = OFF
    super(args)
  end

  def toggle
    @status = !status
  end

  def process(signal)
    return Signal.new(:hi, [], key) if signal.strength == :hi
    toggle
    if status == ON
      get_signal(:hi)
    else
      get_signal(:lo)
    end
  end
end

class ConjunctionModule < ComModule
  attr_accessor :inputs
  def init_inputs(input_arr)
    @inputs = input_arr.map{|k| [k, :lo]}.to_h
  end

  def process(signal)
    inputs[signal.source] = signal.strength

    if inputs.values.all?(:hi)
      get_signal(:lo)
    else
      get_signal(:hi)
    end
  end
end

class BroadcastModule < ComModule
end
