# --- Day 5: If You Give A Seed A Fertilizer ---
# --- Part Two ---

# Everyone will starve if you only plant such a small number of seeds.
# Re-reading the almanac, it looks like the seeds: line actually describes
# ranges of seed numbers.

# The values on the initial seeds: line come in pairs. Within each pair, the
# first value is the start of the range and the second value is the length of
# the range.

# Consider all of the initial seed numbers listed in the ranges on the first
# line of the almanac. What is the lowest location number that corresponds to
# any of the initial seed numbers?

class Range
  def intersection(other)
    return nil if (self.max < other.begin or other.max < self.begin)
    [self.begin, other.begin].max..[self.max, other.max].min
  end
  alias_method :&, :intersection

  def minus(other)
    # they don't overlap
    return nil if (self.max < other.begin or other.max < self.begin)
    # the other is completely covering this range
    return nil if (self.begin >= other.begin && self.max <= other.max)

    # only one difference range when the beginnings or endings are equal
    if self.begin >= other.begin
      return [other.max+1..self.max]
    elsif self.max <= other.max
      return [self.begin..other.begin-1]
    end

    [(self.begin..other.begin-1), (other.max+1..self.max)]
  end
end

class TranslationRange
  def initialize destination, source, size
    @source_range = (source..(source+size-1))
    @diff = destination - source
  end

  def source_range
    @source_range
  end

  def overlap? range
    !intersection(range).nil?
  end

  def intersection range
    @source_range & range
  end

  def translate range
    (range.begin + @diff)..(range.max + @diff)
  end
end

require 'pry-byebug'
Translator = Struct.new(:list, keyword_init: true) do
  def translate(input_range)
    changed = []
    unchanged = [input_range]
    # binding.pry if input_range.begin == 74

    list.each do |tr|
      new_unchanged = []
      unchanged.each do |range|
        if tr.overlap? range
          changed << tr.translate(tr.intersection(range))
          new_unchanged << range.minus(tr.intersection(range))
        else
          new_unchanged << range
        end
      end
      unchanged = new_unchanged.flatten.compact
    end
    changed + unchanged
  end
end

input = seeds = nil

require "benchmark"
puts "Reading input..."
puts Benchmark.measure { input = File.read("input.txt").split("\n") }
puts "Done."


puts "Finding seeds..."
puts Benchmark.measure {
seeds = input.shift.split.find_all {|v| v.match? /\d/ }.map(&:to_i)
seeds = seeds.each_slice(2).map { |pair| (pair[0]..(pair[0]+pair[1]-1)) }.flatten
}
puts "#{seeds.length} found."

trans_ranges = []
translators = []

puts "Building the translation ranges..."
puts Benchmark.measure {
input.each do |line|
  case
  when line.match(/[:]/) && trans_ranges.length > 0
    puts "Creating Translator, #{trans_ranges.length} ranges..."
    translators << Translator.new(list: trans_ranges)
    trans_ranges = []
  when line.match(/[\d]/)
    trans_ranges << TranslationRange.new(*line.split.map(&:to_i))
  else
  end
end
translators << Translator.new(list: trans_ranges)
}
puts "#{translators.length} Translators created"


puts "Processing #{translators.length} translators and #{seeds.length} seed ranges... "

locations = []

puts Benchmark.measure {
seeds.each do |seed_range|
  puts "Processing seed range: #{seed_range}..."
  ranges = [seed_range]
  translators.each do |translator|
    puts "Processing translator #{translator}"
    ranges = ranges.map { |r| translator.translate(r) }.flatten.compact
    puts "Ranges after processing: #{ranges}"
  end
  locations << ranges.min_by {|r| r.begin }
end
}

puts "Translators processed, calculating minimum... "
puts locations.join ", "
min = locations.min_by {|v| v.begin }.begin


print "*********************  Answer: #{min}  *********************"

