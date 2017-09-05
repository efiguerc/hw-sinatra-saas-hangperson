class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  
  attr_accessor :word, :guesses, :wrong_guesses
  
  def initialize(word)
    @word = word
    @guesses = ""
    @wrong_guesses = ""
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

  def guess(letter)
    raise ArgumentError, "nil argument to guess" if letter == nil
    raise ArgumentError, "no letter provided to guess" if letter.empty?
    raise ArgumentError, "not a valid letter to guess" unless letter =~ /^[a-zA-Z]$/
    c = letter.downcase
    return false if @guesses.include?(c) || @wrong_guesses.include?(c)
    if @word.include? c
      @guesses += c
    else
      @wrong_guesses += c
    end
    true
  end
  
  def word_with_guesses
    partial_word = ""
    @word.each_char do |c|
      if @guesses.include? c
        partial_word += c
      else
        partial_word += '-'
      end
    end
    partial_word
  end
  
  def check_win_or_lose
    return :lose if (@guesses.size + @wrong_guesses.size) >= 7
    if word_with_guesses.include? '-'
      return :play
    else
      return :win
    end
  end
end
