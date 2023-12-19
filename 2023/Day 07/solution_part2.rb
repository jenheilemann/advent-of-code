# --- Day 7: Camel Cards ---
# --- Part Two ---

# To make things a little more interesting, the Elf introduces one additional
# rule. Now, J cards are jokers - wildcards that can act like whatever card
# would make the hand the strongest type possible.

# To balance this, J cards are now the weakest individual cards, weaker even
# than 2. The other cards stay in the same order: A, K, Q, T, 9, 8, 7, 6, 5, 4,
# 3, 2, J.

# J cards can pretend to be whatever card is best for the purpose of determining
# hand type; for example, QJJQ2 is now considered four of a kind. However, for
# the purpose of breaking ties between two hands of the same type, J is always
# treated as J, not the card it's pretending to be: JKKK2 is weaker than QQQQ2
# because J is weaker than Q.

# Using the new joker rule, find the rank of every hand in your set. What are
# the new total winnings?


class TestMain < Minitest::Test
  def test_run
    example = "32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483"
    assert_equal(5905, Main.run!(example))
  end
end

class TestHand < Minitest::Test
  def test_five_a_kind
    assert_equal(7, Hand.extract_rank('22222'.split('')))
    assert_equal(7, Hand.extract_rank('2J222'.split('')))
  end

  def test_four_a_kind
    assert_equal(6, Hand.extract_rank('26222'.split('')))
    assert_equal(6, Hand.extract_rank('26J22'.split('')))
    assert_equal(6, Hand.extract_rank('26JJ2'.split('')))
  end

  def test_full_house
    assert_equal(5, Hand.extract_rank('26622'.split('')))
    assert_equal(5, Hand.extract_rank('266J2'.split('')))
  end

  def test_three_a_kind
    assert_equal(4, Hand.extract_rank('25557'.split('')))
    assert_equal(4, Hand.extract_rank('266J7'.split('')))
  end

  def test_two_pair
    assert_equal(3, Hand.extract_rank('26627'.split('')))
  end

  def test_one_pair
    assert_equal(2, Hand.extract_rank('23455'.split('')))
    assert_equal(2, Hand.extract_rank('2345J'.split('')))
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
    when tally.length == 1 ||
         tally.length == 2 && tally.keys.any?('J')
      HandTypes::FIVE_OF_A_KIND

    when (tally.length == 2 && tally.values.any?(4)) ||
         (tally.length == 3 && tally.keys.any?('J') &&
            (tally.values.any?(3) || tally['J'] == 2))
      HandTypes::FOUR_OF_A_KIND

    when tally.length == 2 ||
         tally.length == 3 && tally.keys.any?('J')
      HandTypes::FULL_HOUSE

    when tally.length == 3 && tally.values.any?(3) ||
         tally.length == 4 && tally.keys.any?('J') && tally.values.any?(2)
      HandTypes::THREE_OF_A_KIND

    when tally.length == 3 ||
         tally.length == 4 && tally.keys.any?('J')
      HandTypes::TWO_PAIR

    when tally.length == 4 ||
         tally.length == 5 && tally.keys.any?('J')
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
      'T' => 10,
      '9' => 9,
      '8' => 8,
      '7' => 7,
      '6' => 6,
      '5' => 5,
      '4' => 4,
      '3' => 3,
      '2' => 2,
      'J' => 1,
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
  def self.run!(input)
    hands = input.split("\n").map{|str| Hand.from_input(str)}
    hands.sort!
    hands.each_with_index.inject(0){ |sum, (hand, idx)| sum + hand.score(idx+1) }
  end
end
