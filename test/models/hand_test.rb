require 'test_helper'

class HandTest < ActiveSupport::TestCase
  setup do
    @high_card       = Hand.generate(card(:A,:H), card(10,:S), card(5,:H),  card(3,:H),  card(2,:H))
    @pair            = Hand.generate(card(:A,:H), card(:A,:S), card(5,:H),  card(3,:H),  card(2,:H))
    @two_pair        = Hand.generate(card(:A,:H), card(:A,:S), card(5,:H),  card(5,:S),  card(2,:H))
    @three_of_a_kind = Hand.generate(card(:A,:H), card(:A,:S), card(:A,:D), card(3,:H),  card(2,:H))
    @straight        = Hand.generate(card(:A,:H), card(:K,:H), card(:Q,:H), card(:J,:H), card(10,:D))
    @flush           = Hand.generate(card(:A,:H), card(10,:H), card(5,:H),  card(3,:H),  card(2,:H))
    @full_house      = Hand.generate(card(:A,:H), card(:A,:S), card(5,:H),  card(5,:S),  card(5,:D))
    @four_of_a_kind  = Hand.generate(card(:A,:H), card(:A,:S), card(:A,:D), card(:A,:C), card(2,:H))
    @straight_flush  = Hand.generate(card(:A,:H), card(:K,:H), card(:Q,:H), card(:J,:H), card(10,:H))
  end

  test "Hands compare appropriately" do
    assert @straight_flush > @four_of_a_kind
    assert @four_of_a_kind > @full_house 
    assert @full_house > @flush 
    assert @flush > @straight 
    assert @straight > @three_of_a_kind 
    assert @three_of_a_kind > @two_pair 
    assert @two_pair > @pair 
    assert @pair > @high_card

    assert @straight_flush > @high_card
    assert @flush > @two_pair

    assert @straight_flush == @straight_flush
    assert @four_of_a_kind == @four_of_a_kind
    assert @full_house == @full_house
    assert @flush == @flush
    assert @straight == @straight
    assert @three_of_a_kind == @three_of_a_kind
    assert @two_pair == @two_pair
    assert @pair == @pair
    assert @high_card == @high_card
  end

  test "Hands can report names" do
    assert_equal "Straight Flush", @straight_flush.score_calculation.scoring_cards_name
    assert_equal "High Card", @high_card.score_calculation.scoring_cards_name
  end

  private
  def card(value, suit)
    Card.new(value: value.to_s.to_sym, suit: suit.to_sym)
  end
end
