require_relative 'game'

available_words = File.readlines('words.txt').filter_map { |word| word.chomp if word.chomp.length >= 5 && word.chomp.length <= 12 }

g = Game.new(available_words.sample)
