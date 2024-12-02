# --- Day 16: Proboscidea Volcanium ---

# You scan the cave for other options and discover a network of pipes and
# pressure-release valves. You aren't sure how such a system got into a volcano,
# but you don't have time to complain; your device produces a report (your
# puzzle input) of each valve's flow rate if it were opened (in pressure per
# minute) and the tunnels you could use to move between the valves.

# There's even a valve in the room you and the elephants are currently standing
# in labeled AA. You estimate it will take you one minute to open a single valve
# and one minute to follow any tunnel from one valve to another. What is the
# most pressure you could release?

# Making your way through the tunnels like this, you could probably open many or
# all of the valves by the time 30 minutes have elapsed. However, you need to
# release as much pressure as possible, so you'll need to be methodical.

# Work out the steps to release the most pressure in 30 minutes. What is the
# most pressure you can release?

require 'memoist'
require 'set'

EXAMPLE1 = <<~'EXAMPLE'
        Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
        Valve BB has flow rate=13; tunnels lead to valves CC, AA
        Valve CC has flow rate=2; tunnels lead to valves DD, BB
        Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
        Valve EE has flow rate=3; tunnels lead to valves FF, DD
        Valve FF has flow rate=0; tunnels lead to valves EE, GG
        Valve GG has flow rate=0; tunnels lead to valves FF, HH
        Valve HH has flow rate=22; tunnel leads to valve GG
        Valve II has flow rate=0; tunnels lead to valves AA, JJ
        Valve JJ has flow rate=21; tunnel leads to valve II
        EXAMPLE

class TestMain < Minitest::Test
  def test_run
    assert_equal(1651, Main.run!(EXAMPLE1, time: 30))
  end
end

class Main
  class << self
    def run!(input, time: 30)

    end
  end
end
