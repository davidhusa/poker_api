# Poker Calculator API
# by David Husa

This application has an API endpoint that will evaluate the highest scoring poker hand out of a poker game of up to ten players.

To use the API, send a POST request to /api/v1/calculate with the Content-Type as "application/json" containing an array of objects each with one of two optional fields: name and cards. The name is a string corresponding to the name of that player, the cards are an array of exactly five objects with two required fields: value and suit. The suit must be the first letter of a poker suit, and the value must be a number between 2 and 10 or the first letter of the name of a face card. If you do not pass a name, a name will be generated, and if you do not pass any cards, a hand will be generated based on a shuffled deck minus the cards already used.

If your request is valid (5 cards in each hand, no redundant cards, etc.) then the response will be a JSON object with:
1) an array of "winners" with the name of the one or more winners (in case of ties).
2) a string of the name of the "winning_hand".
3) a array of objects with information about each hand sorted in the order of the value of the hand. This allows you to see what hands were randomly generated.

# SETUP
This application has no use for a database at the moment, so there's no need to intialize it. Just install ruby 2.3.1, run `bundle install` and start the server with `rails s`. Run the test suite with `rake`.

# USING THE APPLICATION
Here's some example curl commands to exercise the application:

From the example below:
curl -H "Content-Type: application/json" -X POST -d '[{"name":"Toki","cards":[{"suit":"hearts","value":"10"},{"suit":"hearts","value":"2"},{"suit":"hearts","value":"4"},{"suit":"hearts","value":"J"},{"suit":"hearts","value":"A"}]},{"name":"Swiskar","cards":[{"suit":"clubs","value":"2"},{"suit":"hearts","value":"3"},{"suit":"diamonds","value":"4"},{"suit":"hearts","value":"6"},{"suit":"hearts","value":"5"}]},{"name":"Nathan"},{},{}]' http://0.0.0.0:3000/api/v1/calculate

Two totally randomly generated players:
curl -H "Content-Type: application/json" -X POST -d '[{},{}]' http://0.0.0.0:3000/api/v1/calculate

# EXAMPLE
Say you want to have a game with two players named Toki and Swiskar with known hands, one player named Nathan with an unknown hand, and two unnamed players with unknown hands. You'd pass an object like this:

[  
  {  
    "name":"Toki",
    "cards":[  
      {  
        "suit":"hearts",
        "value":"10"
      },
      {  
        "suit":"hearts",
        "value":"2"
      },
      {  
        "suit":"hearts",
        "value":"4"
      },
      {  
        "suit":"hearts",
        "value":"J"
      },
      {  
        "suit":"hearts",
        "value":"A"
      }
    ]
  },
  {  
    "name":"Swiskar",
    "cards":[  
      {  
        "suit":"clubs",
        "value":"2"
      },
      {  
        "suit":"hearts",
        "value":"3"
      },
      {  
        "suit":"diamonds",
        "value":"4"
      },
      {  
        "suit":"hearts",
        "value":"6"
      },
      {  
        "suit":"hearts",
        "value":"5"
      }
    ]
  },
  {  
    "name":"Nathan"
  },
  {},
  {}
]

Which would return something like:
{  
  "winning_hand":"Flush",
  "winners":[  
    "Toki"
  ],
  "hands":[  
    {  
      "name":"Toki",
      "hand":"Flush",
      "cards":[  
        "10 of Hearts",
        "2 of Hearts",
        "4 of Hearts",
        "Jack of Hearts",
        "Ace of Hearts"
      ]
    },
    {  
      "name":"Swiskar",
      "hand":"Straight",
      "cards":[  
        "2 of Clubs",
        "3 of Hearts",
        "4 of Diamonds",
        "6 of Hearts",
        "5 of Hearts"
      ]
    },
    {  
      "name":"Player 2",
      "hand":"Two Pair",
      "cards":[  
        "King of Diamonds",
        "6 of Spades",
        "6 of Diamonds",
        "7 of Diamonds",
        "King of Hearts"
      ]
    },
    {  
      "name":"Player 1",
      "hand":"Two Pair",
      "cards":[  
        "King of Clubs",
        "7 of Hearts",
        "2 of Diamonds",
        "2 of Spades",
        "7 of Clubs"
      ]
    },
    {  
      "name":"Nathan",
      "hand":"High Card",
      "cards":[  
        "4 of Spades",
        "Jack of Spades",
        "King of Spades",
        "6 of Clubs",
        "5 of Clubs"
      ]
    }
  ]
}
