class Hand
  include CardCollection
  include Comparable

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

  def last_score_calculation
     @last_score_calculation || score_calculation
  end
end
