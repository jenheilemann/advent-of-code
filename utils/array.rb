
class TestArray < Minitest::Test
  def test_indices
    arr = ['x', 'o', 'x', '.', '.', 'o', 'x']
    assert_equal [0,2,6], arr.indices('x')
    assert_equal [0,2,6], arr.indices{|v| v == "x"}
    assert_equal [0,2,6], arr.indices{|v, i| arr[i] == "x"}
  end
end


class Array
  def indices(value = nil)
    if block_given?
      return self.size.times.select {|i| yield(self[i], i) }
    end
    self.size.times.select {|i| self[i] == value}
  end
end
