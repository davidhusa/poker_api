class Hand
  include CardCollection
  include Comparable
  attr_reader :last_score_calculation

  def self.generate(*cards)
    hand = new
    cards.each do |card|
      hand.add_card card
    end
    hand
  end

  def inspect
    "#<Hand: #{self.cards.map(&:name).join(', ')}>"
  end

  def <=>(other_hand)
    if self.score_calculation == other_hand.score_calculation
      0
    elsif self.last_score_calculation > other_hand.last_score_calculation
      1
    else
      -1
    end
  end

  def score_calculation
    @last_score_calculation = ScoreCalculation.new(self.cards)
  end
end
