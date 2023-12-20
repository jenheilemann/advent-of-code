# --- Day 4: The Ideal Stocking Stuffer ---
# --- Part Two ---

# Now find one that starts with six zeroes.


require 'digest/md5'

class TestMain < Minitest::Test
  def test_run
    skip
    assert_equal(609043, Main.run!('abcdef'))
    assert_equal(1048970, Main.run!('pqrstuv'))
  end
end

class Main
  class << self
    def run!(input)
      input = input.strip
      pat = Regexp.new(/^000000/).freeze
      (1..).each do |n|
        return n if pat.match?(Digest::MD5.hexdigest("#{input}#{n}"))
      end
    end
  end
end
