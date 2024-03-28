# module to house all the gameplay methods
# './lib/modules/playable.rb'
module Playable
  def move_piece(player, turn, board, other_player)
    moving_pieces = player_pieces(board, player)
    move_notation = piece_position(player, alt_colors).split(/,\s*/)
    move_notation = square_occupancy(move_notation, player, board)
    move_notation, temp_piece = legal_move_review(player, move_notation, moving_pieces, board, other_player)
    move_or_capture(player, move_notation, temp_piece, board, other_player)
  end

  def filter_move(move_notation, moving_pieces, player)
    move_notation, temp_piece = correct_piece(moving_pieces, move_notation, player)
    until legal_move?(move_notation, temp_piece)
      illegal_move_msg
      move_notation = piece_position(player, alt_colors).split(/,\s*/)
      move_notation, temp_piece = correct_piece(moving_pieces, move_notation, player)
    end
    return move_notation, temp_piece
  end

  def square_occupancy(move_notation, player, board)
    destination = piece_destination(move_notation)
    while board.squares[destination].occupied_by.color.eql?(player.piece_color)
      square_occupied_msg
      move_notation = piece_position(player, alt_colors).split(/,\s*/)
      destination = piece_destination(move_notation)
    end
    move_notation
  end

  def move_or_capture(player, move_notation, temp_piece, board, other_player)
    destination = piece_destination(move_notation)
    if empty_spot?(destination, board)
      piece_moving(move_notation, player, temp_piece, board)
    elsif board.squares[destination].occupied_by.color.eql?(other_player.piece_color)
      piece_capturing(move_notation, player, temp_piece, board)
    end
  end

  def piece_moving(move_notation, player, temp_piece, board)
    case temp_piece.occupied_by.type
    when 'knight', 'king'
      swap_places(move_notation, temp_piece, board)
    when 'pawn'
      move_pawn_piece(move_notation, player, temp_piece, board)
    else
      move_other_piece(move_notation, player, temp_piece, board)
    end
  end

  def move_pawn_piece(move_notation, player, temp_piece, board)
    starting_pos = player.piece_color.eql?('white') ? 7 : 2
    non_capture_moves = pawn_allowed_moves(starting_pos, temp_piece)
    move_notation = legal_pawn_not(move_notation, non_capture_moves, player, temp_piece)
    # what are the conditions for promoting? I need the piece color and the row number
    temp_piece = pawn_promote_review(player, temp_piece, move_notation)
    swap_places(move_notation, temp_piece, board)
  end

  def move_other_piece(move_notation, player, temp_piece, board)
    until clear_path?(move_notation, player, board)
      blocked_path_msg
      move_notation = piece_position(player, alt_colors).split(/,\s*/)
    end
    destination = piece_destination(move_notation)
    swap_places(move_notation, temp_piece, board)
  end

  def swap_places(move_notation, spot, board)
    destination = piece_destination(move_notation)
    board.squares[destination].add_occupancy(spot.occupied_by)
    add_blank_spot(spot)
  end

  def piece_capturing(move_notation, player, temp_piece, board)
    case temp_piece.occupied_by.type
    when 'knight', 'king'
      capture_piece(move_notation, player, temp_piece, board)
    when 'pawn'
      pawn_capture(move_notation, player, temp_piece, board)
    else
      non_knight_capture(move_notation, player, temp_piece, board)
    end
  end

  def pawn_capture(move_notation, player, temp_piece, board)
    capturing_moves = color_specific_captures(temp_piece)
    move_notation = legal_pawn_not(move_notation, capturing_moves, player, temp_piece)
    temp_piece = pawn_promote_review(player, temp_piece, move_notation)
    capture_piece(move_notation, player, temp_piece, board)
  end

  def non_knight_capture(move_notation, player, spot, board)
    until clear_path?(move_notation, player, board)
      blocked_path_msg
      move_notation = piece_position(player, alt_colors).split(/,\s*/)
    end
    capture_piece(move_notation, player, spot, board)
  end

  def capture_piece(move_notation, player, spot, board)
    destination = piece_destination(move_notation)
    captured = board.squares[destination].occupied_by
    player.update_captured(captured)
    swap_places(move_notation, spot, board)
  end

  # this method will prevent a player from making a move that will put the king piece in check
  def legal_move_review(player, move_notation, moving_pieces, board, other_player)
    move_notation, temp_piece = filter_move(move_notation, moving_pieces, player)
    loop do
      temp_board = object_copy(board)
      piece_copy = object_copy(temp_piece)
      destination = piece_destination(move_notation)
      pseudo_swap(temp_board, piece_copy, destination)
      break unless check?(temp_board, other_player)
      check_move_msg
      move_notation = piece_position(player, alt_colors).split(/,\s*/)
      move_notation, temp_piece = filter_move(move_notation, moving_pieces, player)
    end
    return move_notation, temp_piece
  end

  def pseudo_swap(temp_board, piece_copy, destination)
    temp_square = temp_board.squares[destination].occupied_by
    temp_board.squares[destination].add_occupancy(piece_copy.occupied_by)
    temp_board.squares[piece_copy.coords].add_occupancy(temp_square)
  end
end
