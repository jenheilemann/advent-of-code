# --- Day 1: Not Quite Lisp ---

# An opening parenthesis, (, means he should go up one floor, and a closing
# parenthesis, ), means he should go down one floor.

# The apartment building is very tall, and the basement is very deep; he will
# never find the top or bottom floors.

# To what floor do the instructions take Santa?


class TestMain < Minitest::Test
  def test_run
    assert_equal(0, Main.run!('(())'))
    assert_equal(0, Main.run!('()()'))
    assert_equal(3, Main.run!('((('))
    assert_equal(3, Main.run!('(()(()('))
    assert_equal(-3, Main.run!(')())())'))
  end
end

class Main
  class << self
    def run!(input)
      input.count('(') - input.count(')')
    end
  end
end
