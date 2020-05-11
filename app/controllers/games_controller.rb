require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    9.times do
    @letters << [*"A".."Z"].to_a.sample
    end
  end

  def included?(guess, letters)
    guess.chars.all? do |letter|
      guess.count(letter) <= letters.count(letter)
    end
  end

  def score
    @word = params[:word].upcase
    @letters = params[:sample]
    response = open("https://wagon-dictionary.herokuapp.com/#{@word}")
    dictionary = JSON.parse(response.read)

    if dictionary['found'] && included?(@word, @letters)
      @answer = "Congratulations! #{@word} is a valid word!"
      @score = dictionary['length']
    elsif dictionary['found']
      @answer = "Sorry but #{@word} can't be built out of #{@letters}"
    else
      @answer = "Sorry but #{@word} is not a valid word"
    end
    if session.has_key?(:score)
      session[:score] += @score
    else
      session[:score] = @score
    end
  end
end
