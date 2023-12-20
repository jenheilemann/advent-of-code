# --- Day 1: Not Quite Lisp ---
# --- Part Two ---

# Now, given the same instructions, find the position of the first character
# that causes him to enter the basement (floor -1). The first character in the
# instructions has position 1, the second character has position 2, and so on.

# For example:

#     ) causes him to enter the basement at character position 1.
#     ()()) causes him to enter the basement at character position 5.

# What is the position of the character that causes Santa to first enter the
# basement?


class TestMain < Minitest::Test
  def test_run
    assert_equal(1, Main.run!(')'))
    assert_equal(5, Main.run!('()())'))
  end
end

class Main
  class << self
    def run!(input)
      count = 0
      floor = 0
      input.chars.each do |char|
        count += 1
        if char == '('
          floor += 1
        else
          floor -= 1
        end
        if floor < 0
          return count
        end
      end
    end
  end
end
