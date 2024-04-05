# frozen_string_literal: false

# './lib/modules/promptable'
module Promptable
  def refine_name(count)
    player_info_msg
    new_player_msg(count)
    p_name = gets.chomp
    until p_name =~ /^[a-zA-Z0-9_]+$/
      blank_name_msg
      new_player_msg(count)
      p_name = gets.chomp
    end
    p_name
  end

  def user_decision
    replay_msg
    decision = gets.chomp.downcase
    until decision_verified?(decision)
      error_msg
      replay_msg
      decision = gets.chomp.downcase
    end
    decision
  end

  def piece_position(player, alt_colors)
    move_msg(player, alt_colors)
    move_to = gets.chomp
    until format_verified?(move_to)
      error_msg
      move_msg(player, alt_colors)
      move_to = gets.chomp
    end
    move_to
  end

  def prompt_save
    game_save_msg
    choice = gets.chomp
    until decision_verified?(choice)
      error_msg
      game_save_msg
      choice = gets.chomp
    end
    choice
  end

  def prompt_continuation
    continuation_msg
    choice = gets.chomp
    until decision_verified?(choice)
      error_msg
      continuation_msg
      choice = gets.chomp
    end
    choice
  end

  def user_load
    open_game_msg
    choice = gets.chomp
    until decision_verified?(choice)
      error_msg
      open_game_msg
      choice = gets.chomp
    end
    choice
  end
end
