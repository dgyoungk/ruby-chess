# frozen_string_literal: false

# './lib/modules/fileable.rb'
module Fileable
  def create_save_dir
    Dir.mkdir 'saves' unless Dir.exist? 'saves'
  end

  def prompt_game_load(file_path)
    if File.exist?(file_path)
      choice = user_load
      choice.eql?('y') ? open_saved_game(file_path) : new_game
    else
      new_game
    end
  end

  def open_saved_game(file_path)
    loaded_game = deserialize(load_saved_file(file_path))
    loaded_game.start_game(loaded_game)
  end

  def save_game(match, file_path)
    save_to_file(file_path, serialize(match))
    saved_msg
    continue = prompt_continuation
    cut_game_short if continue.eql?('n')
  end
end
