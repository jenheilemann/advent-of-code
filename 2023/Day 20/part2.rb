# --- Day 20: Pulse Propagation ---
# --- Part Two ---

# The final machine responsible for moving the sand down to Island Island has a
# module attached named rx. The machine turns on when a single low pulse is sent
# to rx.

# Reset all modules to their default states. Waiting for all pulses to be fully
# handled after each button press, what is the fewest number of button presses
# required to deliver a single low pulse to the module named rx?


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
    skip
    assert_equal(1, Main.run!(EXAMPLE1))
    assert_equal(1, Main.run!(EXAMPLE2))
  end
end

class Main
  class << self
    def run!(input)
      broadcaster, modules = module_factory(input.strip.split("\n"))
      counts = {hi: 0, lo: 0}
      events = { 'vm' => [],'lm' => [],'jd' => [],'fv' => []}
      10000.times do |t|
        counts[:lo] += 1 # push the button!
        signals = [broadcaster.get_signal(:lo)]
        until signals.empty?
          current = signals.shift
          counts[current.strength] += current.targets.length
          current.targets.each do |target|
            if target == 'zg' && current.strength == :hi
              puts "#{t} #{current} (#{events[current.source]})"
              events[current.source] << t
            end
            next if modules[target].nil?
            signals << modules[target].process(current)
          end
        end
      end
      puts "events: #{events}"
      puts events.values.inject(1) {|s,n| s*(n[1]-n[0]) }
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
