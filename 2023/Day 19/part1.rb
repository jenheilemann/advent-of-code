# --- Day 19: Aplenty ---

# To start, each part is rated in each of four categories:

#     x: Extremely cool looking
#     m: Musical (it makes a noise when you hit it)
#     a: Aerodynamic
#     s: Shiny

# Then, each part is sent through a series of workflows that will ultimately
# accept or reject the part. Each workflow has a name and contains a list of
# rules; each rule specifies a condition and where to send the part if the
# condition is true. The first rule that matches the part being considered is
# applied immediately, and the part moves on to the destination described by the
# rule. (The last rule in each workflow has no condition and always applies if
# reached.)

# If a part is sent to another workflow, it immediately switches to the start of
# that workflow instead and never returns. If a part is accepted (sent to A) or
# rejected (sent to R), the part immediately stops any further processing.

# The system works, but it's not keeping up with the torrent of weird metal
# shapes. The Elves ask if you can help sort a few parts and give you the list
# of workflows and some part ratings (your puzzle input).

# The workflows are listed first, followed by a blank line, then the ratings of
# the parts the Elves would like you to sort. All parts begin in the workflow
# named 'in'.

# Sort through all of the parts you've been given; what do you get if you add
# together all of the rating numbers for all of the parts that ultimately get
# accepted?

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
    assert_equal(19114, Main.run!(EXAMPLE1))
  end
end

class Main
  class << self
    def run!(input)
      workflows_s, parts_s = input.strip.split("\n\n")
      workflows = workflows_s.split("\n").map{|s| [s.split('{')[0], Workflow.from_input(s)] }.to_h
      parts = parts_s.split("\n").map{|s| Part.from_input(s) }

      parts.sum(0) do |part|
        find_parts_value(part, 'in', workflows)
      end
    end

    def find_parts_value(part, current_key, workflows)
      return 0 if current_key == 'R'
      return part.total if current_key == 'A'

      workflow = workflows[current_key]
      find_parts_value(part, workflow.process_part(part), workflows)
    end
  end
end

class TestPart < Minitest::Test
  def test_from_input
    part = Part.from_input('{x=787,m=2655,a=1222,s=2876}')
    assert_equal(787, part.x)
    assert_equal(2655, part.m)
    assert_equal(1222, part.a)
    assert_equal(2876, part.s)
  end

  def test_total
    part = Part.from_input('{x=787,m=2655,a=1222,s=2876}')
    assert_equal(787+2655+1222+2876, part.total)
  end
end

Part = Struct.new(:x, :m, :a, :s) do
  class << self
    def from_input(str)
      x,m,a,s = str.scan(/\d+/).map(&:to_i)
      new(x,m,a,s)
    end
  end

  def total
    x + m + a + s
  end
end

class TestWorkflow < Minitest::Test
  def test_from_input
    workflow = Workflow.from_input('px{a<2006:qkq,m>2090:A,rfg}')
    assert_equal('px', workflow.label)
    assert_equal('rfg', workflow.default)
    assert_equal(['a','<',2006,'qkq'], workflow.actions[0])
    assert_equal(['m','>',2090,'A'], workflow.actions[1])
  end

  def test_process_part
    part = Part.from_input('{x=787,m=2655,a=1222,s=2876}')
    workflow = Workflow.from_input('px{a<2006:qkq,m>2090:A,rfg}')
    assert_equal 'qkq', workflow.process_part(part)
    part = Part.from_input('{x=787,m=2655,a=2006,s=2876}')
    assert_equal 'A', workflow.process_part(part)
    part = Part.from_input('{x=787,m=2090,a=2006,s=2876}')
    assert_equal 'rfg', workflow.process_part(part)
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
        caps[2] = caps[2].to_i
        caps
      }
    end
  end

  def process_part(part)
    actions.each do |action|
      val = part.send(action[0])
      case action[1]
      when '<'
        return action[3] if val < action[2]
      when '>'
        return action[3] if val > action[2]
      end
    end
    default
  end
end
