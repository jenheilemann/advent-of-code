class TestPosition < Minitest::Test
  def test_from_input
    str = 'Sensor at x=16, y=7'
    location = Position.from_input(str)
    assert_kind_of Position, location
    assert_equal 16, location.x
    assert_equal 16, location.col
    assert_equal 7, location.y
    assert_equal 7, location.row

    str = 'closest beacon is at x=15, y=3'
    location = Position.from_input(str)
    assert_kind_of Position, location
    assert_equal 15, location.x
    assert_equal 15, location.col
    assert_equal 3, location.y
    assert_equal 3, location.row
  end

  def test_plus
    p1 = Position.new(x: -4, y: 6)
    p2 = Position.new(x: 3, y: 2)
    assert_equal -1, (p1 + p2).x
    assert_equal 8, (p2 + p1).y
  end

  def test_minus
    p1 = Position.new(x: -4, y: 6)
    p2 = Position.new(x: 3, y: 2)
    assert_equal Position[-7,4], p1 - p2
    assert_equal Position[7,-4], p2 - p1
  end

  def test_magnitude
    p1 = Position.new(x: 3, y: 4)
    assert_equal 5, p1.magnitude
    p1 = Position.new(x: 3, y: 3)
    assert_equal Math.sqrt((3 ** 2) * 2), p1.magnitude
  end

  def test_equality
    p1 = Position.new(x: 1, y: 1)
    p2 = Position.new(x: 1, y: 1)
    assert_equal p1, p2
    p3 = Position.new(x: 3, y: 3)
    refute_equal p1, p3
  end

  def test_taxicab_distance_to
    p1 = Position.new(x: 0, y: 0)
    p2 = Position.new(x: 7, y: 8)
    assert_equal 15, p1.taxicab_distance_to(p2)
    p3 = Position.new(x: -7, y: -8)
    assert_equal 15, p1.taxicab_distance_to(p3)
    assert_equal 30, p2.taxicab_distance_to(p3)
  end
end

class Vector
  def to_vector
    self
  end
end

class Position
  attr_reader :x, :y

  class << self
    def from_input(str)
      x, y = str.scan /-?\d+/
      new(x: x.to_i, y: y.to_i)
    end
    def from_vector(vec)
      return vec if vec.is_a? Position
      raise ArgumentError.new("Arg is a #{vec.class}, not a Vector.") unless vec.class == Vector
      new(x: vec[0].to_i, y: vec[1].to_i)
    end
    def [](*arr)
      from_vector(Vector[*arr])
    end
  end

  def initialize(x:, y:)
    @x = x
    @y = y
  end

  def taxicab_distance_to(other)
    r = self - other
    r.x.abs + r.y.abs
  end

  def + other
    self.class.from_vector(self.to_vector + other.to_vector)
  end
  def - other
    self.class.from_vector(self.to_vector - other.to_vector)
  end
  def == other
    return false unless [Position, Vector].include? other.class
    self.to_vector == other.to_vector
  end
  def eql? other
    self == other
  end
  def hash
    to_vector.hash
  end

  def magnitude; to_vector.magnitude; end
  def to_vector; Vector[x, y]; end
  def to_a; to_vector.to_a; end
  def row; y; end
  def col; x; end
end
