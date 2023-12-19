# --- Part Two ---

# The sandstorm is upon you and you aren't any closer to escaping the wasteland.
# It's going to take significantly more steps to escape!

# What if the map isn't for people - what if the map is for ghosts? Are ghosts
# even bound by the laws of spacetime? Only one way to find out.

# After examining the maps a bit longer, your attention is drawn to a curious
# fact: the number of nodes with names ending in A is equal to the number ending
# in Z! If you were a ghost, you'd probably just start at every node that ends
# with A and follow all of the paths at the same time until they all
# simultaneously end up at nodes that end with Z.

# Simultaneously start on every node that ends with A. How many steps does it
# take before you're only on nodes that end with Z?


class TestMain < Minitest::Test
  def example1
    "LR

11A = (11B, XXX)
11B = (XXX, 11Z)
11Z = (11B, XXX)
22A = (22B, XXX)
22B = (22C, 22C)
22C = (22Z, 22Z)
22Z = (22B, 22B)
XXX = (XXX, XXX)"
  end

  def test_run
    assert_equal(6, Main.run!(example1))
  end

  def test_process_input
    Main.process_input(example1)
    assert_equal(["L", "R"], Main.instructions)
    assert_kind_of(Hash, Main.nodes)
    first_node = Main.nodes.values.first
    assert_kind_of(Node, first_node)
    assert_equal("11A", first_node.address)
    assert_equal("11B", first_node.left)
    assert_equal("XXX", first_node.right)
  end

  def test_start_nodes
    Main.process_input(example1)
    start_nodes = Main.start_nodes
    assert_equal start_nodes.first, Main.nodes["11A"]
    assert_equal start_nodes.last, Main.nodes["22A"]
  end
end

class TestNode < Minitest::Test
  def test_from_input
    node = Node.from_input("CCC = (ZZZ, GGG)")
    assert_kind_of(Node, node)
    assert_equal("CCC", node.address)
    assert_equal("ZZZ", node.left)
    assert_equal("GGG", node.right)
  end

  def test_extract_address
    assert_equal("CCC", Node.extract_address("CCC = (ZZZ, GGG)"))
    assert_equal("BCA", Node.extract_address("BCA = (ZZZ, GGG)"))
  end

  def test_start_node
    assert Node.start_node?("BCA")
    refute Node.start_node?("ABC")
  end

  def test_end_node
    assert Node.end_node?("XYZ")
    refute Node.end_node?("ZYX")
  end
end

class Main
  class << self
    def run!(input)
      process_input(input)
      walk_paths
    end

    def walk_paths
      min_steps = start_nodes.map{|n| walk_path(n.address) }
      min_steps.reduce(1, :lcm)
    end

    def walk_path(address)
      steps = 0
      endless_instructions = instructions.cycle
      until nodes[address].end_node?
        address = nodes[address].send(endless_instructions.next)
        steps += 1
      end
      steps
    end

    def start_nodes
      nodes.values.select {|node| node.start_node? }
    end

    def process_input(input)
      input = input.split("\n")
      @@instructions = input.first.split("")
      @@nodes = input[2..].map {|n| [Node.extract_address(n), Node.from_input(n)] }.to_h
    end

    def instructions; @@instructions; end
    def nodes; @@nodes; end
  end
end


Node = Struct.new(:address, :left, :right, keyword_init: true) do
  class << self
    def from_input(input)
      new(address: extract_address(input), left: input[7..9], right: input[12..14])
    end

    def extract_address(input)
      input[0..2]
    end

    def start_node?(address)
      address[-1] == "A"
    end

    def end_node?(address)
      address[-1] == "Z"
    end
  end

  def start_node?
    self.class.start_node?(address)
  end
  def end_node?
    self.class.end_node?(address)
  end

  alias :L :left
  alias :R :right
end
