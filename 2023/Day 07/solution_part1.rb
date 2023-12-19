# --- Day 7: Camel Cards ---

# Camel Cards is sort of similar to poker except it's designed to be easier to
# play while riding a camel.

# In Camel Cards, you get a list of hands, and your goal is to order them based
# on the strength of each hand. A hand consists of five cards labeled one of A,
# K, Q, J, T, 9, 8, 7, 6, 5, 4, 3, or 2. The relative strength of each card
# follows this order, where A is the highest and 2 is the lowest.

# Every hand is exactly one type. From strongest to weakest, they are:

    # Five of a kind, where all five cards have the same label: AAAAA
    # Four of a kind, where four cards have the same label and one card has a
    #     different label: AA8AA
    # Full house, where three cards have the same label, and the remaining two
    #     cards share a different label: 23332
    # Three of a kind, where three cards have the same label, and the remaining
    #     two cards are each different from any other card in the hand: TTT98
    # Two pair, where two cards share one label, two other cards share a second
    #     label, and the remaining card has a third label: 23432
    # One pair, where two cards share one label, and the other three cards have
    #     a different label from the pair and each other: A23A4
    # High card, where all cards' labels are distinct: 23456

# Hands are primarily ordered based on type; for example, every full house is
# stronger than any three of a kind.

# If two hands have the same type, a second ordering rule takes effect. Start by
# comparing the first card in each hand. If these cards are different, the hand
# with the stronger first card is considered stronger. If the first card in each
# hand have the same label, however, then move on to considering the second card
# in each hand. If they differ, the hand with the higher second card wins;
# otherwise, continue with the third card in each hand, then the fourth, then
# the fifth.

# So, 33332 and 2AAAA are both four of a kind hands, but 33332 is stronger
# because its first card is stronger. Similarly, 77888 and 77788 are both a full
# house, but 77888 is stronger because its third card is stronger (and both
# hands have the same first and second card).

# To play Camel Cards, you are given a list of hands and their corresponding bid
# (your puzzle input).

# Now, you can determine the total winnings of this set of hands by adding up
# the result of multiplying each hand's bid with its rank.

# Find the rank of every hand in your set. What are the total winnings?

class TestMain < Minitest::Test
  def test_run
    example = "32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483"
    assert_equal(6440, Main.run!(example))
  end
end

class TestHand < Minitest::Test
  def test_five_a_kind
    assert_equal(7, Hand.extract_rank('22222'.split('')))
  end

  def test_four_a_kind
    assert_equal(6, Hand.extract_rank('26222'.split('')))
  end

  def test_full_house
    assert_equal(5, Hand.extract_rank('26622'.split('')))
  end

  def test_three_a_kind
    assert_equal(4, Hand.extract_rank('25557'.split('')))
  end

  def test_two_pair
    assert_equal(3, Hand.extract_rank('26627'.split('')))
  end

  def test_one_pair
    assert_equal(2, Hand.extract_rank('23455'.split('')))
  end

  def test_high_card
    assert_equal(1, Hand.extract_rank('23456'.split('')))
  end
end

# hands and rank, highest wins
module HandTypes
  FIVE_OF_A_KIND  = 7
  FOUR_OF_A_KIND  = 6
  FULL_HOUSE      = 5
  THREE_OF_A_KIND = 4
  TWO_PAIR        = 3
  ONE_PAIR        = 2
  HIGH_CARD       = 1
end


Hand = Struct.new(:cards, :bid, :rank, keyword_init: true) do
  def self.from_input(str)
    cards, bid = *str.split
    rank = extract_rank(cards.split(''))
    self.new(cards: hand_to_num(cards.split('')), rank: rank, bid: bid.to_i)
  end

  def self.extract_rank(cards_array)
    tally = cards_array.tally

    case
    when tally.length == 1
      HandTypes::FIVE_OF_A_KIND

    when (tally.length == 2 && tally.values.any?(4))
      HandTypes::FOUR_OF_A_KIND

    when tally.length == 2
      HandTypes::FULL_HOUSE

    when tally.length == 3 && tally.values.any?(3)
      HandTypes::THREE_OF_A_KIND

    when tally.length == 3
      HandTypes::TWO_PAIR

    when tally.length == 4
      HandTypes::ONE_PAIR
    else
      HandTypes::HIGH_CARD
    end
  end

  def self.hand_to_num cards
    cards.map {|v| convert_to_number(v) }
  end

  def self.convert_to_number(value)
    conversions = {
      'A' => 14,
      'K' => 13,
      'Q' => 12,
      'J' => 11,
      'T' => 10,
      '9' => 9,
      '8' => 8,
      '7' => 7,
      '6' => 6,
      '5' => 5,
      '4' => 4,
      '3' => 3,
      '2' => 2,
    }
    return conversions[value]
  end

  def <=>(other)
    return rank <=> other.rank if rank != other.rank
    cards <=> other.cards
  end

  def score(idx)
    idx * bid
  end
end

class Main
  class << self
    def run!(input)
      hands = input.split("\n").map{|str| Hand.from_input(str)}
      hands.sort!
      hands.each_with_index.inject(0){ |sum, (hand, idx)| sum + hand.score(idx+1) }
    end
  end
end
