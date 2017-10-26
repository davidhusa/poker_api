class Deck
  include CardCollection

  def initialize
    super
    Card::SUITS.each do |suit|
      Card::VALUES.each do |value|
        card = Card.new(value: value, suit: suit)
        self.add_card(card)
      end
    end
  end

  def inspect
    "#<Deck: #{self.cards.size} cards. Top card: #{self.cards.empty? ? 'N/A' : self.cards.last.name}>"
  end

  def shuffle
    @cards = self.cards.shuffle
    self
  end

  def draw(hand)
    raise "invalid hand" unless hand.class == Hand
    hand.add_card(self.cards.pop)
  end
end
