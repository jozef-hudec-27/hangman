require_relative 'game'

available_words = File.readlines('words.txt').filter_map { |word| word.chomp if word.chomp.length >= 5 && word.chomp.length <= 12 }

# MAIN LOOP
loop do
    game = Game.new(available_words.sample)

    # GAME LOOP
    loop do
        puts "> ROUND #{game.round}"
        puts HANGMAN_STAGES[game.wrong_guesses]
        puts "> Letters already used: #{game.used_letters.join(', ')}"
        puts "> Hint: #{game.hint}"

        puts "Please enter a single letter."

        begin
            guess = gets.chomp.downcase
            raise 'Invalid guess' unless game.guess_valid?(guess)  
        rescue 
            if game.used_letter?(guess)
                puts "> You have already used this letter. Please pick another one."
            else
                puts "> Invalid guess. Please try again."    
            end
            retry        
        else
            game.guess_letter(guess)

            if game.wrong_guesses == 7
                puts HANGMAN_STAGES[-1]
                puts "> You lost! The secret word was #{game.secret_word.join('')}."
                break
            elsif game.hint.count('_') == 0
                puts "You guessed all the letters! The secret word was #{game.hint.split(' ').join('')}."
                break
            end
        end
    end

    puts "> Do you want to play again? ('y')"
    play_again = gets.chomp.downcase

    break unless play_again == 'y'
end
