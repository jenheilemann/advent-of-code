require 'matrix'
require 'minitest'

UTIL0 ="
#..
#..
...
..#"

class TestMap < Minitest::Test
  def test_exists
    assert_kind_of(Map, Map[])
    assert_kind_of(Matrix, Map[])
  end
  def test_from_input
    map = Map.from_input(UTIL0)
    assert_kind_of(Matrix, map)
    assert_equal("#", map[0,0])
    assert_equal("#", map[0,1])
    assert_equal(".", map[1,0])
    assert_equal 4, map.height
    assert_equal 3, map.width

    map = Map.from_input(UTIL0) {|s| s.ord }
    assert_equal(35, map[0,0])
    assert_equal(46, map[1,0])
    assert_equal(35, map[0,1])

    map = Map.from_input(UTIL0) {|s, col, row| "#{col},#{row}" }
    assert_equal('0,0', map[0,0])
    assert_equal('1,0', map[1,0])
    assert_equal('2,3', map[2,3])

    map = Map.from_input(UTIL0) {|s, col, row| Position.new(x:col, y: row) }
    assert_equal(Position.new(x:0, y:0), map[0,0])
    assert_equal(Position.new(x:1, y:0), map[1,0])
    assert_equal(Position.new(x:2, y:3), map[map[2,3]])
  end
  def test_find_indexes
    map = Map.from_input(UTIL0)
    assert_equal([[0, 0], [1, 0], [3, 2]], map.find_indexes("#"))

    assert_equal([[0, 0], [1, 0], [3, 2]], map.find_indexes {|el| el == "#"})
  end

  def test_outside_bounds
    map = Map.from_input(UTIL0)
    assert map.outside_bounds?(Position.new(x:-1,y:0))
    assert map.outside_bounds?(Position.new(x:3,y:0))
    assert map.outside_bounds?([0,-1])
    assert map.outside_bounds?([0,4])
    assert map.outside_bounds?([3,0])

    refute map.outside_bounds?(Position.new(x:0,y:0))
    refute map.outside_bounds?(Position.new(x:0,y:3))
    refute map.outside_bounds?([2,3])
    refute map.outside_bounds?([2,2])
  end
end


class Map < Matrix
  UP    = ::Vector[ 0,-1 ]
  DOWN  = ::Vector[ 0, 1 ]
  LEFT  = ::Vector[-1, 0 ]
  RIGHT = ::Vector[ 1, 0 ]

  class << self
    def from_input(str)
      arr = str.strip.split("\n").each_with_index.map{|s, row|
        if block_given?
          s.split("").each_with_index.map{|substr, col| yield(substr, col, row) }
        else
          s.split("")
        end
      }
      self[*arr]
    end
  end

  alias :height :row_count
  alias :width :column_count

  alias :old_brackets :[]
  def [](col, row = nil)
    arr = col.is_a?(Array) ? col : (row.nil? ? col.to_a : [col, row])
    old_brackets(*arr.reverse)
  end

  def outside_bounds?(col, row = nil)
    arr = col.is_a?(Array) ? col : (row.nil? ? col.to_a : [col, row])
    return true if arr[0] < 0 || arr[1] < 0
    return true if arr[1] >= row_count || arr[0] >= column_count
    false
  end
  alias :off_edge? :outside_bounds?

  def find_indexes(value = nil)
    indexes = []

    self.each_with_index do |element, row, col|
      if block_given?
        indexes << [row, col] if yield(element)
      else
        indexes << [row, col] if element == value
      end
    end

    indexes
  end
end

