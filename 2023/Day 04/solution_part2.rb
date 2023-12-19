# --- Day 4: Scratchcards ---
# --- Part Two ---

# Just as you're about to report your findings to the Elf, one of you realizes
# that the rules have actually been printed on the back of every card this whole
# time.

# There's no such thing as "points". Instead, scratchcards only cause you to win
# more scratchcards equal to the number of winning numbers you have.

# Specifically, you win copies of the scratchcards below the winning card equal
# to the number of matches. So, if card 10 were to have 5 matching numbers, you
# would win one copy each of cards 11, 12, 13, 14, and 15.

# Copies of scratchcards are scored like normal scratchcards and have the same
# card number as the card they copied. So, if you win a copy of card 10 and it
# has 5 matching numbers, it would then win a copy of the same cards that the
# original card 10 won: cards 11, 12, 13, 14, and 15. This process repeats until
# none of the copies cause you to win any more cards. (Cards will never make you
# copy a card past the end of the table.)

# Process all of the original and copied scratchcards until no more scratchcards
# are won. Including the original set of scratchcards, how many total
# scratchcards do you end up with?

class CardPile < Hash
  def process!
    self.each do |game, card|
      score = card.calc_score

      (game+1..game+score).each do |num|
        make_copies(num, card.copies)
      end
    end
  end

  def make_copies num, copies
    return if self[num].nil?
    self[num].copy(copies)
  end
end

Scratchcard = Struct.new(:card, :winners, :numbers, :copies, keyword_init: true) do
  def calc_score
    (winners & numbers).length
  end

  def self.from_input(line)
    game, all_numbers = *line.split(":")
    card = game.split.last.to_i
    winners = all_numbers.split('|').first.split
    numbers = all_numbers.split('|').last.split
    [card, self.new(card: card, winners: winners, copies: 1, numbers: numbers)]
  end

  def copy(num)
    self.copies += num
  end
end

input = File.read("input.txt").split("\n")
pile = CardPile.new
input.each do |value|
  num, card = *Scratchcard.from_input(value)
  pile[num] = card
end

pile.process!
puts pile.values.map(&:copies).inject(0, &:+)
