module CardCollection
  attr_reader :cards

  def initialize
    @cards = []
  end

  def add_card(card_to_add)
    raise "invalid card" unless card_to_add.class == Card

    @cards << card_to_add
  end

  def remove_card(card_to_remove)
    raise "invalid card" unless card_to_remove.class == Card

    index_to_delete = @cards.find_index do |card|
      card_to_remove.identical_card(card)
    end

    if index_to_delete
      @cards.delete_at index_to_delete
    else
      false
    end
  end
end
