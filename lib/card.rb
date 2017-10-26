class Card
  include Comparable
  attr_reader :value, :suit
  SUITS = %i< H C D S >
  VALUES = %i< 2 3 4 5 6 7 8 9 10 J Q K A > # in order of value in Poker

  def initialize(value:, suit:)
    raise "invalid value: #{value}" unless VALUES.include?(value.to_sym)
    raise "invalid suit: #{suit}"  unless SUITS.include?(suit.to_sym)
    @value = value.to_sym
    @suit = suit.to_sym
  end

  def inspect
    "#<Card: #{name}>"
  end

  VALUE_NAMES = { J: "Jack", Q: "Queen", K: "King", A: "Ace" }
  def value_title
    VALUE_NAMES[self.value] || self.value.to_s
  end

  SUIT_NAMES = { H: "Hearts", C: "Clubs", D: "Diamonds", S: "Spades" }
  def suit_title
    SUIT_NAMES[self.suit]
  end

  def name
    "#{value_title} of #{suit_title}"
  end

  def value_as_integer
    VALUES.index(self.value)
  end

  def <=>(other_card)
    if other_card.value == self.value
      0
    elsif self.value_as_integer > other_card.value_as_integer
      1
    else
      -1
    end
  end

  def one_lower(other_card)
    self.value_as_integer - other_card.value_as_integer == -1
  end

  def identical_card(other_card)
    other_card.value == self.value && other_card.suit == self.suit
  end
end
