require_relative 'game'
require_relative 'utils'

available_words = File.readlines('words.txt').filter_map do |word|
  word.chomp if word.chomp.length >= 5 && word.chomp.length <= 12
end

Dir.mkdir('savefiles') unless Dir.exist?('savefiles')
save_files_directory = Dir.new('savefiles')

catch :main_loop do
  # MAIN LOOP
  loop do
    puts "\n> If you want to load an existing game, enter 'load'."
    input = gets.chomp

    game, current_save_filename = *new_game(input, save_files_directory, available_words)

    # GAME LOOP
    loop do
      output_new_round_info(game)

      begin
        guess = gets.chomp.downcase

        if guess == 'save'
          save_game(current_save_filename, save_files_directory, game)
          throw :main_loop
        end

        throw :main_loop if guess == 'quit'
        raise 'Invalid guess' unless game.guess_valid?(guess)
      rescue
        if game.used_letter?(guess)
          puts '> You have already used this letter. Please pick another one.'
        else
          puts '> Invalid guess. Please try again.'
        end
        retry
      else
        game.guess_letter(guess)

        if game.wrong_guesses == HANGMAN_STAGES.length - 1 || game.hint.count('_').zero?
          output_end_game_messages(game)
          break
        end
      end
    end

    delete_current_save(current_save_filename)

    puts "> Do you want to play again? ('y')"
    play_again = gets.chomp.downcase

    break unless play_again == 'y'
  end
end

puts '👋 See you later!'
