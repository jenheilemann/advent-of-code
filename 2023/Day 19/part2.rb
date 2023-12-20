# --- Day 19: Aplenty ---
# --- Part Two ---

# Even with your help, the sorting process still isn't fast enough.

# One of the Elves comes up with a new plan: rather than sort parts individually
# through all of these workflows, maybe you can figure out in advance which
# combinations of ratings will be accepted or rejected.

# Each of the four ratings (x, m, a, s) can have an integer value ranging from a
# minimum of 1 to a maximum of 4000. Of all possible distinct combinations of
# ratings, your job is to figure out which ones will be accepted.

# In the above example, there are 167409079868000 distinct combinations of
# ratings that will be accepted.

# Consider only your list of workflows; the list of part ratings that the Elves
# wanted you to sort is no longer relevant. How many distinct combinations of
# ratings will be accepted by the Elves' workflows?


EXAMPLE1 = <<~'EXAMPLE'
          px{a<2006:qkq,m>2090:A,rfg}
          pv{a>1716:R,A}
          lnx{m>1548:A,A}
          rfg{s<537:gd,x>2440:R,A}
          qs{s>3448:A,lnx}
          qkq{x<1416:A,crn}
          crn{x>2662:A,R}
          in{s<1351:px,qqz}
          qqz{s>2770:qs,m<1801:hdj,R}
          gd{a>3333:R,R}
          hdj{m>838:A,pv}

          {x=787,m=2655,a=1222,s=2876}
          {x=1679,m=44,a=2067,s=496}
          {x=2036,m=264,a=79,s=2244}
          {x=2461,m=1339,a=466,s=291}
          {x=2127,m=1623,a=2188,s=1013}
          EXAMPLE

WORKFLOW ='ex{x>10:one,m<20:two,a>30:R,A}'

class TestMain < Minitest::Test
  def test_run
    assert_equal(167409079868000, Main.run!(EXAMPLE1))
  end
end

class Main
  class << self
    def run!(input)
      workflows_s, _ = input.strip.split("\n\n")
      workflows = workflows_s.split("\n").map{|s| [s.split('{')[0], Workflow.from_input(s)] }.to_h
      find_accepted_ranges(workflows).sum(0, &:combinations)
    end

    # solution to part 2 shamelessly stolen from 'leftfish'
    # https://github.com/Leftfish/Advent-of-Code-2023/blob/main/19/d19.py
    def find_accepted_ranges(workflows)
      start = RangedPart.new('in')
      q = [start]
      accepted = []

      while q.length > 0
        current = q.shift
        workflow = workflows[current.label]
        not_covered = {x: current.x, m: current.m, a: current.a, s: current.s}

        workflow.actions.each do |(key, op, value, next_step)|
          to_update = not_covered.dup

          if op == '<' && to_update[key].max > value
            to_update[key]   = to_update[key].min..(value-1)
            not_covered[key] = value..not_covered[key].max
          end
          if op == '>' && to_update[key].min < value
            to_update[key]   = (value+1)..to_update[key].max
            not_covered[key] = not_covered[key].min..value
          end
          new_ranges = RangedPart.new(next_step, *to_update.values)
          if next_step == "A"
            accepted << new_ranges
          elsif next_step != "R"
            q << new_ranges
          end
        end
        new_ranges = RangedPart.new(workflow.default, *not_covered.values)
        if workflow.default == 'A'
          accepted << new_ranges
        elsif workflow.default != "R"
          q << new_ranges
        end
      end
      accepted
    end
  end
end

class TestRangedPart < Minitest::Test
  def test_combinations
    part = RangedPart.new('in', x = 1..5, m = 1..4, a = 1..3, s = 1..2)
    assert_equal(5*4*3*2, part.combinations)
    part = RangedPart.new('in')
    assert_equal(4000*4000*4000*4000, part.combinations)
  end
end

class RangedPart
  attr_accessor :x, :m, :a, :s, :label
  def initialize(label, x = 1..4000, m = 1..4000, a = 1..4000, s = 1..4000)
    @x = x
    @m = m
    @a = a
    @s = s
    @label = label
  end

  def combinations
    [x, m, a, s].inject(1) {|v, r| v * r.size }
  end
end

class TestWorkflow < Minitest::Test
  def test_from_input
    workflow = Workflow.from_input('px{a<2006:qkq,m>2090:A,rfg}')
    assert_equal('px', workflow.label)
    assert_equal('rfg', workflow.default)
    assert_equal([:a,'<',2006,'qkq'], workflow.actions[0])
    assert_equal([:m,'>',2090,'A'], workflow.actions[1])
  end
end

Workflow = Struct.new(:label, :actions, :default) do
  class << self
    def from_input(str)
      label, actions_str = str.split('{')
      actions = actions_str[..-2].split(',')
      default = actions.pop
      actions = process_actions(actions)

      new(label, actions, default)
    end

    def process_actions(str)
      str.map {|s|
        caps = s.match(/([xmas])([><])(\d+):(\w+)/).captures
        if caps.length < 4
          raise StandardError.new("Couldn't find matches in str: '#{s}'")
        end
        caps[0] = caps[0].to_sym
        caps[2] = caps[2].to_i
        caps
      }
    end
  end
end
