require 'pry-byebug'
# './lib/modules/thinkable.rb'
module Thinkable

  def decision_verified?(p_choice)
    %w[y n].include?(p_choice)
  end

  def format_verified?(user_notation, status = [])
    pure_info = user_notation.split(/,\s*/).join('')
    pure_info.size.eql?(5) ? status.push(true) : status.push(false)
    piece_initials.keys.include?(pure_info.chars.first) ? status.push(true)  : status.push(false)
    pure_info.slice(1..).chars.all? { |info| info.to_i <= 8 } ? status.push(true) : status.push(false)
    return status.all?(true)
  end

  def piece_matched?(move_notation, spot)
    return location_match?(spot.coords, move_notation) && type_match?(spot, move_notation)
  end

  def location_match?(coords, move_notation)
    return (coords).eql?(piece_location(move_notation))
  end

  def type_match?(spot, move_notation)
    return spot.occupied_by.type.eql?(piece_type(move_notation))
  end

  # methods that help chess pieces make a legal move i.e. checking moving path
  def empty_spot?(coords, board)
    return board.squares[coords].occupied_by.color.eql?('none')
  end

  def legal_move?(move_notation, temp_piece)
    temp_dest = piece_destination(move_notation)
    move_to_make = create_move(temp_dest, temp_piece.coords)
    return temp_piece.occupied_by.possible_moves.include?(move_to_make)
  end

  def clear_path?(move_notation, player, board)
    destination = piece_destination(move_notation)
    player_pieces = board.squares.values.select { |spot| spot.occupied_by.color.eql?(player.piece_color) }
    player_pieces.each do |spot|
      if piece_matched?(move_notation, spot)
        if (caller[0][/`.*'/][1..-2]).include?('move')
          return check_path(destination, spot, board)
        else
          return check_capture_path(destination, spot, board)
        end
      end
    end
  end

  # game draw condition checking
  def dead_position?(board)
    return board.squares.values.select { |spot| spot.occupied_by.color.eql?('none') }.size.eql?(62)
  end

  def stalemate?(board, player)
    temp_board = Marshal.load(Marshal.dump(board))
    player_pieces = player_pieces(temp_board, player)
    king_piece = player_king_piece(player_pieces)
    other_pieces = temp_board.squares.values.reject { |spot| spot.occupied_by.color.eql?(player.piece_color) }
    rival_pieces = opponent_pieces(other_pieces)
    if king_stale?(temp_board, king_piece, rival_pieces)
      return pieces_stale?(temp_board, player_pieces, rival_pieces)
    else
      return false
    end
  end

  def king_stale?(board, king_piece, rival_pieces)

    king_moves = valid_moves(board, king_piece)
    return true if king_moves.empty?
    k_results = check_for_stale(board, king_moves, king_piece, rival_pieces)
    return k_results.all?(true)
  end

  def pieces_stale?(board, player_pieces, rival_pieces)
    p_results = player_pieces.each_with_object([]) do |piece, p_arr|
      player_p_moves = determine_moves(board, piece)
      next if player_p_moves.empty?
      stale_piece = check_for_stale(board, player_p_moves, piece, rival_pieces)
      p_arr.push(stale_piece.any?(true))
    end
    return p_results.all?(true)
  end

  def checkmate?(board, player, other_player)

    if check?(board, player)
      return stalemate?(board, other_player)
    end
  end

  def check?(board, player, results = [])
    checking_pieces = piece_initials.values.reject { |type| type.eql?('king')  }
    checking_pieces.each do |p_type|
      pieces = pieces_on_board(board, player, p_type)
      piece_status = pieces.each_with_object([]) { |spot, arr| arr.push(piece_check(board, spot)) }
      results.push(piece_status.flatten)
    end
    return results.flatten.any?(true)
  end
end
