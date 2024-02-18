# './lib/modules/thinkable.rb'
module Thinkable
  # this method will change the background colors
  def bg_colorize(string, rgb_values)
    "\e[48;2;#{rgb_values}m#{string}\e[0m"
  end

  def fg_colorize(string, rgb_values)
    %(\e[38;2;#{rgb_values}m#{string}\u0020\e[0m)
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

  def decision_verified?(p_choice)
    %w[y n].include?(p_choice)
  end

  # game draw condition checking
  def check_dead_position(board)
    return board.squares.filter { |coords, spot| spot.occupied_by.instance_of? ChessPiece }.size.eql?(62)
  end

  def piece_position(player)
    move_msg(player)
    move_to = gets.chomp
    until format_verified?(move_to)
      error_msg
      move_msg(player)
      move_to = gets.chomp
    end
    move_to
  end

  def format_verified?(user_notation)
    # things to check:
    # first one should be a letter included in the initials hash
    # total length excluding punctuation and whitespace should be 4
    # all numbers should be inside the chess board i.e. less than 8
    pure_info = user_notation.split(/,\s*/).join('')
    return true if pure_info.size.eql?(4)
    return true if piece_initials.keys.include?(pure_info.chars.first)
    return pure_info.slice(1..).chars.all? { |info| info < '8' }
  end

  def piece_type(move_notation)
    return piece_initials[move_notation.first.chars.first]
  end

  def piece_destination(move_notation)
    return move_notation.last.chars.map(&:to_i)
  end

  def piece_column(move_notation)
    return move_notation.first.chars.last.to_i
  end

  def piece_matched?(move_notation, player, coords, spot)
    return column_match?(coords, move_notation) && type_match?(spot, move_notation) && color_match?(spot, player)
  end

  def column_match?(coords, move_notation)
    return (coords.last).eql?(piece_column(move_notation))
  end

  def type_match?(spot, move_notation)
    return spot.occupied_by.type == piece_type(move_notation)
  end

  def color_match?(spot, player)
    return spot.occupied_by.color == player.piece_color
  end
end
