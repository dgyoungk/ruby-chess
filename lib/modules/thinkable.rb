# './lib/modules/thinkable.rb'
module Thinkable

  def decision_verified?(p_choice)
    %w[y n].include?(p_choice)
  end

  def format_verified?(user_notation, status = [])
    pure_info = user_notation.split(/,\s*/).join('')
    pure_info.size.eql?(4) ? status.push(true) : status.push(false)
    piece_initials.keys.include?(pure_info.chars.first) ? status.push(true)  : status.push(false)
    pure_info.slice(1..).chars.all? { |info| info.to_i <= 8 } ? status.push(true) : status.push(false)
    return status.all?(true)
  end

  def piece_matched?(move_notation, spot)
    return column_match?(spot.coords, move_notation) && type_match?(spot, move_notation)
  end

  def column_match?(coords, move_notation)
    return (coords.last).eql?(piece_column(move_notation))
  end

  def type_match?(spot, move_notation)
    return spot.occupied_by.type.eql?(piece_type(move_notation))
  end

  # methods that help chess pieces make a legal move i.e. checking moving path
  def empty_spot?(coords, board)
    return board.squares[coords].occupied_by.instance_of? ChessPiece
  end

  # checking whether the move is possible...
  # get the move by subtracting the current coords from the destination coords
  # return whether the piece's possible_moves includes the resulting coords
  def legal_move?(move_notation, spot)
    temp_dest = piece_destination(move_notation)
    move_to_make = [temp_dest.first - spot.coords.first, temp_dest.last - spot.coords.last]
    return spot.occupied_by.possible_moves.include?(move_to_make)
  end

  def clear_path?(move_notation, player, board)
    destination = piece_destination(move_notation)
    player_pieces = board.squares.values.select { |spot| spot.occupied_by.color.eql?(player.piece_color) }
    player_pieces.each do |spot|
      if piece_matched?(move_notation, player, spot)
        return check_path(destination, spot, board)
      end
    end
  end

  # game draw condition checking
  def dead_position?(board)
    return board.squares.values.select { |spot| spot.occupied_by.instance_of? ChessPiece }.size.eql?(62)
  end

  def stalemate?(board, player)
    player_pieces = player_pieces(board, player)
    other_pieces = board.squares.values.reject { |spot| spot.occupied_by.color.eql?(player.piece_color) }
    rival_pieces = opponent_pieces(other_pieces)
    king_piece = player_king_piece(player_pieces)
    status = king_overlapping(board, king_piece, rival_pieces)
    return status.all?(true)
  end

  def checkmate?(board, player)
    return check?(board, player) && stalemate?(board, player)
  end

  def check?(board, player, results = [])
    # I need to get every single ranked piece e.g. Rook, Knight, Bishop, Queen
    # and check if a King piece is in their path AND a piece is not blocking the way
    # only exception is the knight, I just need to check if a king is one move away
    # so 2 methods, one for the knight piece and another for the non-knight pieces
    checking_pieces = piece_initials.values.reject { |type| type.eql?('king')  }
    # each element in types will be an array of nodes that contain pieces
    checking_pieces.each do |type|
      pieces = pieces_on_board(board, player, type)
      results = pieces.each_with_object([]) { |spot, arr| arr.push(piece_check(board, spot)) }
    end
    return results.any?(true)
  end
end
