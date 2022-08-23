require_relative 'game'

available_words = File.readlines('words.txt').filter_map { |word|
  word.chomp if word.chomp.length >= 5 && word.chomp.length <= 12
}

catch :main_loop do
  # MAIN LOOP
  loop do
    puts "\n> If you want to load an existing game, enter 'load'."
    input = gets.chomp

    if input == 'load'
      available_save_files = Dir.new('savefiles').children

      if available_save_files == []
        puts '> There are no saves available.'
        sleep(1)
      else
        puts "> Which save do you want to load? Available: #{available_save_files.join(', ')}."
        sleep(1)
        puts "> Changed your mind? Enter 'q' to start a new game."

        begin
          file_name = gets.chomp
          raise 'Save not found' unless available_save_files.include?(file_name) || file_name == 'q'
        rescue
          puts '> Save not found. Try again.'
          retry
        else
          puts "> Loading '#{file_name}'..."
          sleep(1)
          serialized_game = File.read("savefiles/#{file_name}")
          game = Marshal.load(serialized_game)
        end
      end
    else
      game = Game.new(available_words.sample)
    end

    # GAME LOOP
    loop do
      puts "\n> ROUND #{game.round}"
      puts HANGMAN_STAGES[game.wrong_guesses]
      puts "> Letters already used: #{game.used_letters.join(', ')}"
      puts "> Hint: #{game.hint}"

      puts 'Please enter a single letter.'

      begin
        guess = gets.chomp.downcase

        if guess == 'save'
          puts '> What should your save be called?'
          save_name = gets.chomp.strip
          save_name = "save#{Dir.new('savefiles').children.length}" if save_name == ''

          puts "> Saving your game as '#{save_name}'"
          sleep(1)

          serialized_game = Marshal.dump(game)
          File.open("savefiles/#{save_name}", 'w') { |file| file.puts serialized_game }
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

        if game.wrong_guesses == 7
          puts HANGMAN_STAGES[-1]
          puts "> You lost! The secret word was #{game.secret_word.join('')}."
          break
        elsif game.hint.count('_').zero?
          puts "You guessed all the letters! The secret word was #{game.hint.split(' ').join('')}."
          break
        end
      end
    end

    puts "> Do you want to play again? ('y')"
    play_again = gets.chomp.downcase

    break unless play_again == 'y'
  end
end

puts '> See you later!'
