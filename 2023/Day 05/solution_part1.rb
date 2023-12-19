# --- Day 5: If You Give A Seed A Fertilizer ---

# "While you wait for the ferry, maybe you can help us with our food production
# "problem. The latest Island Island Almanac just arrived and we're having
# "trouble making sense of it."

# The almanac (your puzzle input) lists all of the seeds that need to be
# planted. It also lists what type of soil to use with each kind of seed, what
# type of fertilizer to use with each kind of soil, what type of water to use
# with each kind of fertilizer, and so on. Every type of seed, soil, fertilizer
# and so on is identified with a number, but numbers are reused by each category
# - that is, soil 123 and fertilizer 123 aren't necessarily related to each
# other.

# The rest of the almanac contains a list of maps which describe how to convert
# numbers from a source category into numbers in a destination category. That
# is, the section that starts with seed-to-soil map: describes how to convert a
# seed number (the source) to a soil number (the destination). This lets the
# gardener and his team know which soil to use with which seeds, which water to
# use with which fertilizer, and so on.

# Rather than list every source number and its corresponding destination number
# one by one, the maps describe entire ranges of numbers that can be converted.
# Each line within a map contains three numbers: the destination range start,
# the source range start, and the range length.

# Any source numbers that aren't mapped correspond to the same destination
# number.

# The gardener and his team want to get started as soon as possible, so they'd
# like to know the closest location that needs a seed. Using these maps, find
# the lowest location number that corresponds to any of the initial seeds. To do
# this, you'll need to convert each seed number through other categories until
# you can find its corresponding location number.

# What is the lowest location number that corresponds to any of the initial seed
# numbers? pile of colorful cards. How many points are they worth in total?

class TranslationRange
  def initialize destination, source, size
    @source_range = (source..(source+size-1))
    @diff = destination - source
  end

  def matches? value
    @source_range.include? value
  end

  def translate value
    value + @diff
  end
end

Translator = Struct.new(:list, keyword_init: true) do
  def translate(value)
    range_match = list.detect {|v| v.matches? value }

    return value if range_match.nil?
    range_match.translate value
  end
end

require "test/unit"
class TestTranslationRange < Test::Unit::TestCase

  def test_matching
    testee = TranslationRange.new(50, 98, 2)
    assert_equal(false, testee.matches?(97))
    assert_equal(true,  testee.matches?(98))
    assert_equal(true,  testee.matches?(99))
    assert_equal(false, testee.matches?(100))
  end

  def test_translation
    testee = TranslationRange.new(50, 98, 2)
    assert_equal(50, testee.translate(98))
    assert_equal(51, testee.translate(99))
  end
end

class TestTranslator < Test::Unit::TestCase
  def test_translate
    ranges = [TranslationRange.new(50, 98, 2), TranslationRange.new(52, 50, 48)]
    testee = Translator.new(list: ranges)
    assert_equal(81, testee.translate(79))
    assert_equal(14, testee.translate(14))
    assert_equal(57, testee.translate(55))
    assert_equal(13, testee.translate(13))
  end
end


input = File.read("input.txt").split("\n")
seeds = input.shift.split.find_all {|v| v.match? /\d/ }.map(&:to_i)
trans_ranges = []
translators = []

# build the translation ranges
input.each do |line|
  case
  when line.match(/[:]/) && trans_ranges.length > 0
    translators << Translator.new(list: trans_ranges)
    trans_ranges = []
  when line.match(/[\d]/)
    trans_ranges << TranslationRange.new(*line.split.map(&:to_i))
  else
  end
end
translators << Translator.new(list: trans_ranges)

locations = seeds.map do |seed|
  translators.each do |translator|
    seed = translator.translate(seed)
  end
  seed
end

print locations, "\n", locations.min, "\n"

