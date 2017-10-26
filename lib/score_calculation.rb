class ScoreCalculation
  include Comparable

  attr_reader :hand_value, # integer
              :scoring_cards, # array of cards
              :tie_breaker_values, # array of one or two integers
              :non_scoring_high_cards # array of cards

  POKER_HANDS = { # hand name and score, in order of priority
    straight_flush: 8,
    four_of_a_kind: 7,
    full_house: 6,
    flush: 5,
    straight: 4,
    three_of_a_kind: 3,
    two_pair: 2,
    pair: 1,
    high_card: 0
  }

  def initialize(cards)
    result = nil
    POKER_HANDS.keys.each do |poker_hand|
      result = self.send(:"find_#{poker_hand}", cards)
      break if result
    end

    raise "Score calculation failed" unless result

    @hand_value, @tie_breaker_values, @scoring_cards = result

    @non_scoring_high_cards = (cards - self.scoring_cards).sort {|x,y| y <=> x }
  end

  #                                 0            1       2           3                  4           5        6             7                 8              #
  SCORING_CARDS_NAME_FROM_SCORE = ["High Card", "Pair", "Two Pair", "Three of a Kind", "Straight", "Flush", "Full House", "Four of a Kind", "Straight Flush"]
  def scoring_cards_name
    SCORING_CARDS_NAME_FROM_SCORE[self.hand_value] if self.hand_value
  end

  def inspect
    "#<ScoreCalculation: #{self.scoring_cards_name} [#{self.scoring_cards.map(&:name).join(', ')}] #{self.non_scoring_high_cards.map(&:name).join(', ')}>"
  end

  def <=>(other_score_calculation)
    if self.hand_value == other_score_calculation.hand_value

      self_tie_breaker  = (self.tie_breaker_values - other_score_calculation.tie_breaker_values).max
      other_tie_breaker = (other_score_calculation.tie_breaker_values - self.tie_breaker_values).max
      if self_tie_breaker == nil

        self_unique_high_value  = (self.non_scoring_high_cards.map(&:value_as_integer) - other_score_calculation.non_scoring_high_cards.map(&:value_as_integer)).max
        other_unique_high_value = (other_score_calculation.non_scoring_high_cards.map(&:value_as_integer) - self.non_scoring_high_cards.map(&:value_as_integer)).max
        if self_unique_high_value == nil
          0
        elsif self_unique_high_value > other_unique_high_value
          1
        else
          -1
        end

      elsif self_tie_breaker > other_tie_breaker
        1
      else
        -1
      end

    elsif self.hand_value > other_score_calculation.hand_value
      1
    else
      -1
    end
  end

  private
   # each find_* method must return false or [@hand_value: integer, @tie_breaker_values: array of integers, @non_scoring_high_cards: array of cards]
  def find_straight_flush(cards)
    flushes = group_cards_by_suit(cards).select do |value, cards|
      cards.size >= 5
    end

    straight_flush_results = []
    flushes.each do |suits, cards|
      next unless find_straight_result = find_straight(cards)
      straight_flush_results << find_straight_result
    end

    return false if straight_flush_results.empty?

    straight_flush = straight_flush_results.max_by do |hand_value, tie_breaker_values, scoring_cards|
      tie_breaker_values.first
    end.last
    tie_breaker_values = [straight_flush.first.value_as_integer]

    [POKER_HANDS[:straight_flush], tie_breaker_values, straight_flush]
  end

  def find_four_of_a_kind(cards)
    four_of_a_kinds = group_cards_by_value_as_integer(cards).select do |value, cards|
      cards.size == 4
    end

    return false if four_of_a_kinds.empty?

    four_of_a_kind = four_of_a_kinds[four_of_a_kinds.keys.max]
    tie_breaker_values = [four_of_a_kinds.keys.max]

    [POKER_HANDS[:four_of_a_kind], tie_breaker_values, four_of_a_kind]
  end

  def find_full_house(cards)
    three_of_a_kind = find_three_of_a_kind(cards)
    pair = find_pair(cards)

    return false unless three_of_a_kind && pair

    full_house = three_of_a_kind.last + pair.last
    tie_breaker_values = [three_of_a_kind[1][0]]

    [POKER_HANDS[:full_house], tie_breaker_values, full_house]
  end

  def find_flush(cards)
    flushes = group_cards_by_suit(cards).select do |value, cards|
      cards.size >= 5
    end

    return false if flushes.empty?

    max_value_card = flushes.values.flatten.max
    flush = flushes[max_value_card.suit]
    tie_breaker_values = [max_value_card.value_as_integer]

    [POKER_HANDS[:flush], tie_breaker_values, flush]
  end

  def find_straight(cards)
    last_card = nil
    straight = []

    cards.sort {|x,y| y <=> x }.each do |card|
      if last_card && card.one_lower(last_card) # If you're not the first card, and this card is one lower than the last card
        straight << card
      elsif !last_card || !(card == last_card)  # If you're the first card, or your card isn't equal to (or one lower than) the last card
        straight = [card]
      end

      if straight.size >= 5
        break
      end

      last_card = card
    end

    if straight.size < 5
      false
    else
      tie_breaker_values = [straight.first.value_as_integer]
      [POKER_HANDS[:straight], tie_breaker_values, straight]
    end
  end

  def find_three_of_a_kind(cards)
    three_of_a_kinds = group_cards_by_value_as_integer(cards).select do |value, cards|
      cards.size == 3
    end

    return false if three_of_a_kinds.empty?

    three_of_a_kind = three_of_a_kinds[three_of_a_kinds.keys.max]
    tie_breaker_values = [three_of_a_kinds.keys.max]

    [POKER_HANDS[:three_of_a_kind], tie_breaker_values, three_of_a_kind]
  end

  def find_two_pair(cards)
    pairs = group_cards_by_value_as_integer(cards).select do |value, cards|
      cards.size == 2
    end

    return false unless pairs.size >= 2

    values = pairs.keys.sort {|x,y| y <=> x }
    pairs = pairs[values[0]] + pairs[values[1]]
    tie_breaker_values = values[0..1]

    [POKER_HANDS[:two_pair], tie_breaker_values, pairs]
  end

  def find_pair(cards)
    pairs = group_cards_by_value_as_integer(cards).select do |value, cards|
      cards.size == 2
    end

    return false if pairs.empty?

    pair = pairs[pairs.keys.max]
    tie_breaker_values = [pairs.keys.max]

    [POKER_HANDS[:pair], tie_breaker_values, pair]
  end

  def find_high_card(cards)
    high_card = [cards.max]
    tie_breaker_values = []

    [POKER_HANDS[:high_card], tie_breaker_values, high_card]
  end

  def group_cards_by_value_as_integer(cards)
    group = Hash.new
    cards.each do |card|
      group[card.value_as_integer] ||= []
      group[card.value_as_integer] << card
    end
    group
  end

  def group_cards_by_suit(cards)
    group = Hash.new
    cards.each do |card|
      group[card.suit] ||= []
      group[card.suit] << card
    end
    group
  end
end
