class PokerController < ApplicationController
  def index

    render json: {welcome: 'Send POST request to /calculate with the Content-Type as "application/json", supply an array of objects with a name and cards. The name is a string, the cards are an array of strings describing cards'}
  end

  def calculate
    players, errors = parse_calculation_params(params)

    if errors.empty?
      render status: 200, json: score_players(players)
    else
      render status: 400, json: errors
    end
  end

  private
  def parse_calculation_params(params)
    deck = Deck.new.shuffle # todo use this for random
    players = []
    errors = []

    return [players, ["No JSON data"]] unless params[:_json]

    params[:_json].each do |player_hash|
      name = player_hash[:name] || default_player_name
      
      if !player_hash[:cards] || player_hash[:cards].empty?
        players << { name: name }
        next
      end

      hand = Hand.new
      player_hash[:cards].each do |card_hash|
        begin
          card = parse_card(card_hash)
          if deck.remove_card(card)
            hand.add_card(card)
          else
            errors << "Player \"#{name}\", redundant card #{card.name}"
          end

        rescue
          errors << "Player \"#{name}\", bad card data"
        end
      end

      if hand.cards.size > 5
        errors << "Player \"#{name}\", hand too large"
        break
      elsif hand.cards.size < 5
        errors << "Player \"#{name}\", hand too small"
        break
      end

      players << {name: name, hand: hand}
    end

    players.select do |hash|
      !hash[:hand]
    end.each do |hash|
      hash[:hand] = Hand.new
      5.times do
        deck.draw(hash[:hand])
      end
    end

    errors << "No players" if players.empty?

    [players, errors]
  end

  def parse_card(card_hash)
    suit = card_hash[:suit]
    suit = suit.first.upcase.to_sym

    value = card_hash[:value]
    if value =~ /\A10/
      value = :"10"
    else
      value = value.first.upcase.to_sym
    end

    Card.new(suit: suit, value: value)
  end

  def default_player_name
    @player_number ||= 0
    "Player #{@player_number += 1}"
  end

  def score_players(players)
    return_hash = {}

    return_hash[:winners] = [players.max_by do |player|
      player[:hand]
    end].flatten.map do |player|
      return_hash[:winning_hand] ||= player[:hand].last_score_calculation.scoring_cards_name
      player[:name]
    end

    return_hash[:hands] = players.sort_by do |player|
      player[:hand]
    end.map do |player|
      {
        name: player[:name],
        hand: player[:hand].last_score_calculation.scoring_cards_name,
        cards: player[:hand].cards.map(&:name)
      }
    end.reverse

    return_hash
  end
end

#
# [
#   {
#     "name": "Toki",
#     "cards": [
#       {"suit": "hearts", "value": "10"},
#       {"suit": "hearts", "value": "2"},
#       {"suit": "hearts", "value": "4"},
#       {"suit": "hearts", "value": "J"},
#       {"suit": "hearts", "value": "A"}
#     ]
#   },
#   {
#     "name": "Swiskar",
#     "cards": [
#       {"suit": "hearts", "value": "2"},
#       {"suit": "spades", "value": "3"},
#       {"suit": "clubs", "value": "4"},
#       {"suit": "diamonds", "value": "5"},
#       {"suit": "diamonds", "value": "6"}
#     ]
#   },
#   {
#     "name": "Murderface",
#     "random": "true"
#   }
# ]