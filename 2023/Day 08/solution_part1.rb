# --- Day 8: Haunted Wasteland ---

# One of the pouches is labeled "maps" - sure enough, it's full of documents
# (your puzzle input) about how to navigate the desert. At least, you're pretty
# sure that's what they are; one of the documents contains a list of left/right
# instructions, and the rest of the documents seem to describe some kind of
# network of labeled nodes.

# It seems like you're meant to use the left/right instructions to navigate the
# network. Perhaps if you have the camel follow the same instructions, you can
# escape the haunted wasteland!

# After examining the maps for a bit, two nodes stick out: AAA and ZZZ. You feel
# like AAA is where you are now, and you have to follow the left/right
# instructions until you reach ZZZ.

# This format defines each node of the network individually. For example:


# Of course, you might not find ZZZ right away. If you run out of left/right
# instructions, repeat the whole sequence of instructions as necessary: RL
# really means RLRLRLRLRLRLRLRL... and so on.

# Starting at AAA, follow the left/right instructions. How many steps are
# required to reach ZZZ?

class TestMain < Minitest::Test
  def example1
    "RL

AAA = (BBB, CCC)
BBB = (DDD, EEE)
CCC = (ZZZ, GGG)
DDD = (DDD, DDD)
EEE = (EEE, EEE)
GGG = (GGG, GGG)
ZZZ = (ZZZ, ZZZ)"
  end
  def example2
    "LLR

AAA = (BBB, BBB)
BBB = (AAA, ZZZ)
ZZZ = (ZZZ, ZZZ)"
  end

  def test_run
    assert_equal(2, Main.run!(example1))
    assert_equal(6, Main.run!(example2))
  end

  def test_process_input
    Main.process_input(example1)
    assert_equal(["R", "L"], Main.instructions)
    assert_kind_of(Hash, Main.nodes)
    first_node = Main.nodes.values.first
    assert_kind_of(Node, first_node)
    assert_equal("AAA", first_node.address)
    assert_equal("BBB", first_node.left)
    assert_equal("CCC", first_node.right)
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
end

class Main
  class << self
    def run!(input)
      process_input(input)
      walk_path
    end

    def walk_path
      steps = 0
      address = "AAA"
      endless_instructions = instructions.cycle
      until address == "ZZZ"
        address = nodes[address].send(endless_instructions.next)
        steps += 1
      end
      steps
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
  end

  alias :L :left
  alias :R :right
end
