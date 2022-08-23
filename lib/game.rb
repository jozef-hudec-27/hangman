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

class Game
    attr_reader :round, :wrong_guesses, :used_letters
    
    def initialize(secret_word)
        @round = 0
        @wrong_guesses = 0
        @secret_word = secret_word.split('')
        @used_letters = []
        @hint = Array.new(secret_word.length, '_')
    end

    def guess_letter(letter)
        self.round = round + 1

        prev_unknown_letter_count = hint.count('_')

        secret_word.length.times { |i| @hint[i] = letter if secret_word[i] == letter } 

        new_unknown_letter_count = hint.count('_')

        self.wrong_guesses = wrong_guesses + 1 if prev_unknown_letter_count == new_unknown_letter_count
    end

    def used_letter?(letter)
        used_letters.include?(letter)
    end

    def hint
        hint.join('')
    end

    private

    attr_reader :secret_word
    attr_writer :round, :wrong_guesses
end 
