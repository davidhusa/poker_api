class WelcomeController < ApplicationController
  WELCOME_TEXT = 'Welcome to my poker API!!' +
  ' This service will allow you to evaluate what poker hands have the hightest score.' +
  ' Send a POST request to /api/v1/calculate with the Content-Type as "application/json",' +
  ' containing an array of objects with one of two optional fields: name and cards. The name is a string,' +
  ' the cards are an array of exactly five objects with two required fields: value and suit. The suit must be the first' +
  ' letter of a suit, and the value must be a number between 2 and 10 or the first letter of the name of a face card.' +
  ' If you do not pass the name, one will be generated, and if you do not pass cards, a hand will be generated.'

  def index
    render json: {welcome: WELCOME_TEXT}
  end
end
