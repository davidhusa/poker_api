require 'test_helper'

class HandTest < ActiveSupport::TestCase
  setup do
    @ace = card(:A,:H)
    @king = card(:K,:H)
    @queen = card(:Q,:H)
    @jack = card(:J,:H)
    @ten = card(10,:H)
    @nine = card(9,:H)
    @eight = card(8,:H)
    @seven = card(7,:H)
    @six = card(6,:H)
    @five = card(5,:H)
    @four = card(4,:H)
    @three = card(3,:H)
    @two = card(2,:H)
    @two_of_clubs = card(2,:C)
  end

  test "one_lower method accurately identifies when one card is one lower" do
    assert @king.one_lower(@ace)
    assert @jack.one_lower(@queen)
    assert @three.one_lower(@four)
    assert !@ace.one_lower(@two)
    assert !@ace.one_lower(@ace)
    assert !@two.one_lower(@two)
    assert !@ace.one_lower(@king)
    assert !@ace.one_lower(@two)
    assert !@two.one_lower(@ace)
  end

  test "identical_card method identifies when one card is the same suit and number" do
    assert card(2,:H).identical_card(card(2,:H))
    assert @four.identical_card(@four)
    assert !@two.identical_card(@two_of_clubs)
    assert !@two_of_clubs.identical_card(@two)
  end

  private
  def card(value, suit)
    Card.new(value: value.to_s.to_sym, suit: suit.to_sym)
  end
end
