require_relative 'game'

DIGITS = '0123456789'

def output_new_round_info(game)
  puts "\n> ROUND #{game.round}"
  puts HANGMAN_STAGES[game.wrong_guesses]
  puts "> Letters already used: #{game.used_letters.join(', ')}"
  puts "> Hint: #{game.hint}"

  puts 'Please enter a single letter.'
end

def output_end_game_messages(game)
  if game.hint.count('_').zero?
    puts "🥳 You guessed all the letters! The secret word was #{game.hint.split(' ').join('')}."
  else
    puts HANGMAN_STAGES[-1]
    puts "😿 You lost! The secret word was #{game.secret_word.join('')}."
  end
end

def delete_current_save(filename)
  return unless filename != ''

  puts "> Do you want to delete the save '#{filename}', since you've finished the game? Enter 'y' if yes."
  delete_current_save = gets.chomp.downcase

  return unless delete_current_save == 'y'

  puts "> Deleting #{filename}..."
  sleep(1)
  File.delete("savefiles/#{filename}")
end

def new_game(input, save_files_dir, words)
  return [Game.new(words.sample), ''] unless input == 'load'

  available_save_files = save_files_dir.children

  if available_save_files.empty?
    puts '> There are no saves available. Starting a new game...'
    sleep(1)
    Game.new(words.sample)
  else
    puts "> Which save do you want to load? Available: #{available_save_files.join(', ')}."
    puts "> Changed your mind? Enter 'q' to start a new game."

    begin
      file_name = gets.chomp
      raise 'Save not found' unless available_save_files.include?(file_name) || file_name == 'q'
    rescue
      puts '> Save not found. Try again.'
      retry
    else
      if file_name != 'q'
        puts "> Loading '#{file_name}'..."
        sleep(1)
        serialized_game = File.read("savefiles/#{file_name}")
        [Marshal.load(serialized_game), file_name]
      else
        [Game.new(words.sample), '']
      end
    end
  end
end

def save_name_valid?(savename)
  return false if savename == ''

  savename.chars.each do |char|
    return false unless ALPHABET.include?(char) || DIGITS.include?(char) || '-_'.include?(char)
  end

  true
end

def save_game(cur_save_filename, save_files_dir, game)
  puts "> What should your save be called? (use only letters, numbers, hyphens and underscores) #{"Enter the name of your current save ('#{cur_save_filename}') if you want to overwrite it." if cur_save_filename != ''}"
  puts "> Be careful not to overwrite any existing saves if you don't wish to. They are: #{save_files_dir.children.join(', ')}." unless save_files_dir.children.empty?

  save_name = gets.chomp.strip
  save_name = "save#{save_files_dir.children.length}" unless save_name_valid?(save_name)

  puts "> Saving your game as '#{save_name}'..."
  sleep(1)

  serialized_game = Marshal.dump(game)
  File.open("savefiles/#{save_name}", 'w') { |file| file.puts serialized_game }
end
