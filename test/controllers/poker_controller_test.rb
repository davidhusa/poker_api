require 'test_helper'

class PokerControllerTest < ActionDispatch::IntegrationTest

  test "Properly formed request returns calculations" do
    params = [
      {
        "name": "Toki",
        "cards": [
          {"suit": "hearts", "value": "10"},
          {"suit": "hearts", "value": "2"},
          {"suit": "hearts", "value": "4"},
          {"suit": "hearts", "value": "J"},
          {"suit": "hearts", "value": "A"}
        ]
      },
      {
        "name": "Swiskar",
        "cards": [
          {"suit": "clubs", "value": "2"},
          {"suit": "hearts", "value": "3"},
          {"suit": "diamonds", "value": "4"},
          {"suit": "hearts", "value": "6"},
          {"suit": "hearts", "value": "5"}
        ]
      },
      {
        "name": "Murderface"
      },
      {},
      {}
    ]

    post calculate_url, params: params, as: :json

    assert response.success?

    response_body = JSON.parse(response.body)
    assert response_body["winning_hand"]
    assert response_body["winners"]
    assert_equal 5, response_body["hands"].size
  end

  test "Winner identified correctly" do
    params = [
      {
        "name": "Toki",
        "cards": [
          {"suit": "hearts", "value": "10"},
          {"suit": "hearts", "value": "2"},
          {"suit": "hearts", "value": "4"},
          {"suit": "hearts", "value": "J"},
          {"suit": "hearts", "value": "A"}
        ]
      },
      {
        "name": "Swiskar",
        "cards": [
          {"suit": "clubs", "value": "2"},
          {"suit": "hearts", "value": "3"},
          {"suit": "diamonds", "value": "4"},
          {"suit": "hearts", "value": "6"},
          {"suit": "hearts", "value": "5"}
        ]
      } 
    ]

    post calculate_url, params: params, as: :json

    assert response.success?

    response_body = JSON.parse(response.body)
    expected_response = {
      "winning_hand"=>"Flush",
      "winners"=>["Toki"],
      "hands"=>
        [{"name"=>"Toki",
          "hand"=>"Flush",
          "cards"=>["10 of Hearts", "2 of Hearts", "4 of Hearts", "Jack of Hearts", "Ace of Hearts"]},
         {"name"=>"Swiskar",
          "hand"=>"Straight",
          "cards"=>["2 of Clubs", "3 of Hearts", "4 of Diamonds", "6 of Hearts", "5 of Hearts"]}]}

    assert_equal expected_response["winning_hand"], response_body["winning_hand"]
    assert_equal expected_response["winners"], response_body["winners"]
    assert_equal expected_response["hands"], response_body["hands"]
  end
  
  test "Throws 'No JSON data' if there's no JSON data" do
    post calculate_url, params: nil, as: :json

    assert !response.success?

    assert response.body =~ /No JSON data/
  end

  test "Throws 'No players' if there's no players" do
    post calculate_url, params: [], as: :json

    assert !response.success?

    assert response.body =~ /No players/
  end

  test "Works with 10 players" do
    post calculate_url, params: [{}]*10, as: :json

    assert response.success?
  end

  test "Works with 1 player" do
    post calculate_url, params: [{}], as: :json

    assert response.success?
  end

  test "Throws 'Too many players' if there's 11 or more players" do
    post calculate_url, params: [{}]*11, as: :json

    assert !response.success?

    assert response.body =~ /Too many players/
  end

  test "Throws error if there's a redundant card" do
    params = [
      {
        "name": "Toki",
        "cards": [
          {"suit": "hearts", "value": "10"},
          {"suit": "hearts", "value": "2"},
          {"suit": "hearts", "value": "4"},
          {"suit": "hearts", "value": "J"},
          {"suit": "hearts", "value": "A"}
        ]
      },
      {
        "name": "Swiskar",
        "cards": [
          {"suit": "clubs", "value": "2"},
          {"suit": "hearts", "value": "4"},
          {"suit": "diamonds", "value": "4"},
          {"suit": "hearts", "value": "6"},
          {"suit": "hearts", "value": "5"}
        ]
      } 
    ]

    post calculate_url, params: params, as: :json

    assert !response.success?
    assert response.body =~ /redundant card 4 of Hearts/
  end

  test "Throws error if a hand is too small" do
    params = [
      {
        "name": "Toki",
        "cards": [
          {"suit": "hearts", "value": "10"},
          {"suit": "hearts", "value": "2"},
          {"suit": "hearts", "value": "4"},
          {"suit": "hearts", "value": "A"}
        ]
      },
      {
        "name": "Swiskar",
        "cards": [
          {"suit": "clubs", "value": "2"},
          {"suit": "hearts", "value": "4"},
          {"suit": "diamonds", "value": "4"},
          {"suit": "hearts", "value": "6"},
          {"suit": "hearts", "value": "5"}
        ]
      } 
    ]

    post calculate_url, params: params, as: :json

    assert !response.success?
    assert response.body =~ /hand too small/
  end

  test "Throws error if a hand is too large" do
    params = [
      {
        "name": "Toki",
        "cards": [
          {"suit": "hearts", "value": "10"},
          {"suit": "hearts", "value": "2"},
          {"suit": "hearts", "value": "4"},
          {"suit": "hearts", "value": "J"},
          {"suit": "hearts", "value": "A"}
        ]
      },
      {
        "name": "Swiskar",
        "cards": [
          {"suit": "clubs", "value": "2"},
          {"suit": "clubs", "value": "4"},
          {"suit": "diamonds", "value": "4"},
          {"suit": "hearts", "value": "6"},
          {"suit": "hearts", "value": "5"},
          {"suit": "clubs", "value": "5"}
        ]
      } 
    ]

    post calculate_url, params: params, as: :json

    assert !response.success?
    assert response.body =~ /hand too large/
  end

end
