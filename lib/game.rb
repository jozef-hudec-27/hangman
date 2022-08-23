HANGMAN_STAGES = ['''
    +---+
        |
        |
        |
        |
        |
    =========''', '''
    +---+
    |   |
        |
        |
        |
        |
    =========''', '''
    +---+
    |   |
    O   |
        |
        |
        |
    =========''', '''
    +---+
    |   |
    O   |
    |   |
        |
        |
    =========''', '''
    +---+
    |   |
    O   |
   /|   |
        |
        |
    =========''', '''
    +---+
    |   |
    O   |
   /|\  |
        |
        |
    =========''', '''
    +---+
    |   |
    O   |
   /|\  |
   /    |
        |
    =========''', '''
    +---+
    |   |
    O   |
   /|\  |
   / \  |
        |
    =========''']

ALPHABET = 'abcdefghijklmnopqrstuvwxyz'

class Game
  attr_reader :round, :wrong_guesses, :used_letters, :secret_word

  def initialize(secret_word)
    @round = 1
    @wrong_guesses = 0
    @secret_word = secret_word.split('')
    @used_letters = []
    @hint = Array.new(secret_word.length, '_')
  end

  def guess_letter(letter)
    self.round = round + 1
    used_letters.push(letter)

    prev_unknown_letter_count = hint.count('_')

    secret_word.length.times { |i| @hint[i] = letter if secret_word[i] == letter }

    new_unknown_letter_count = hint.count('_')

    self.wrong_guesses = wrong_guesses + 1 if prev_unknown_letter_count == new_unknown_letter_count
  end

  def used_letter?(letter)
    used_letters.include?(letter)
  end

  def guess_valid?(guess)
    return false if guess.length != 1 || used_letter?(guess)

    ALPHABET.include?(guess)
  end

  def hint
    @hint.join(' ')
  end

  private

  attr_writer :round, :wrong_guesses
end
