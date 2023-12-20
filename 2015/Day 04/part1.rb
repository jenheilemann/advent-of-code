# --- Day 4: The Ideal Stocking Stuffer ---

# Santa needs help mining some AdventCoins (very similar to bitcoins) to use as
# gifts for all the economically forward-thinking little girls and boys.

# To do this, he needs to find MD5 hashes which, in hexadecimal, start with at
# least five zeroes. The input to the MD5 hash is some secret key (your puzzle
# input, given below) followed by a number in decimal. To mine AdventCoins, you
# must find Santa the lowest positive number (no leading zeroes: 1, 2, 3, ...)
# that produces such a hash.

require 'digest/md5'

class TestMain < Minitest::Test
  def test_run
    assert_equal(609043, Main.run!('abcdef'))
    assert_equal(1048970, Main.run!('pqrstuv'))
  end
end

class Main
  class << self
    def run!(input)
      input = input.strip
      pat = Regexp.new(/^00000/).freeze
      (1..1926880).each do |n|
        return n if pat.match?(Digest::MD5.hexdigest("#{input}#{n}"))
      end
    end
  end
end
