# frozen_string_literal: false

require_relative 'thinkable'
# './lib/modules/informable.rb'
module Informable
  include Thinkable

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

  def pawn_promote_review(player, temp_piece, move_notation)
    promoting_pos = player.piece_color.eql?('white') ? 1 : 8
    temp_dest = piece_destination(move_notation)
    temp_piece.add_occupancy(Queen.new('queen', player.piece_color)) if temp_dest.first.eql?(promoting_pos)
    temp_piece
  end

  def correct_piece(player_pieces, move_notation, player)
    temp_piece = selected_piece(player_pieces, move_notation)
    until temp_piece.instance_of? Node
      incorrect_piece_msg
      move_notation = piece_position(player, alt_colors).split(/,\s*/)
      temp_piece = selected_piece(player_pieces, move_notation)
    end
    [move_notation, temp_piece]
  end

  def check_capture_path(destination, spot, board, difference = [])
    difference = create_move(destination, spot.coords) if difference.empty?
    return true if difference.all? { |half| half.eql?(1) || half.eql?(-1) || half.eql?(0) }

    # refining the difference so that the move is 1 square less than the actual move...
    capture_difference = update_difference(difference)
    count = create_count(difference)
    check_empty_spots(capture_difference, count, board, spot.coords).all?(true)
  end

  def check_path(destination, spot, board, difference = [])
    difference = create_move(destination, spot.coords) if difference.empty?
    count = create_count(difference)
    check_empty_spots(difference, count, board, spot.coords).all?(true)
  end

  def check_empty_spots(difference, count, board, starting, results = [])
    temp_dest = create_destination(starting, count)
    return results.push(empty_spot?(temp_dest, board)) if count.eql?(difference)

    limit = count.any?(&:negative?) ? -1 : 1
    until (count <=> difference).eql?(limit)
      occupation = empty_spot?(temp_dest, board)
      return results.push(false) unless occupation

      results.push(occupation)
      count = update_count(count)
      temp_dest = create_destination(starting, count)
    end
    results
  end

  def determine_moves(board, piece)
    case piece.occupied_by.type
    when 'knight'
      piece.occupied_by.possible_moves
    when 'pawn'
      color_specific_captures(piece) + pawn_regular_moves(piece)
    else
      valid_moves(board, piece)
    end
  end

  def piece_check(board, piece)
    # let's have this as the general check method and delegate to knight/non-knight pieces here
    case piece.occupied_by.type
    when 'knight'
      knight_check(board, piece)
    when 'pawn'
      pawn_check(board, piece)
    else
      non_knight_check(board, piece)
    end
  end

  def non_knight_check(board, piece)
    piece_moves = piece.occupied_by.possible_moves
    allowed_moves = piece_moves.reject { |pair| board.squares[create_destination(piece.coords, pair)].nil? }
    results = allowed_moves.each_with_object([]) do |pair, arr|
      temp_dest = create_destination(piece.coords, pair)
      temp_piece = board.squares[temp_dest].occupied_by
      if temp_piece.type.eql?('king') && !temp_piece.color.eql?(piece.occupied_by.color)
        arr.push(check_capture_path(temp_dest, piece, board, pair))
      end
    end
    results.any?(true)
  end

  def pawn_check(board, piece)
    capturing_move = color_specific_captures(piece)
    pawnee_results = check_for_check(board, piece, capturing_move)
    pawnee_results.any?(true)
  end

  def knight_check(board, piece)
    thk = piece.occupied_by.possible_moves
    thk_results = check_for_check(board, piece, thk)
    thk_results.any?(true)
  end

  def check_for_check(board, piece, moves)
    moves.each_with_object([]) do |pair, arr|
      temp_dest = create_destination(piece.coords, pair)
      next if board.squares[temp_dest].nil?

      temp_piece = board.squares[temp_dest].occupied_by
      temp_piece.type.eql?('king') && !temp_piece.color.eql?(piece.occupied_by.color) ? arr.push(true) : arr.push(false)
    end
  end

  def check_for_stale(board, moves, piece, rival_pieces)
    allowed_moves = moves.reject { |pair| board.squares[create_destination(piece.coords, pair)].nil? }
    allowed_moves.each_with_object([]) do |pair, arr|
      temp_board = object_copy(board)
      temp_dest = create_destination(piece.coords, pair)
      # temp_square = temp_board.squares[temp_dest]
      temp_board.squares[temp_dest].add_occupancy(piece.occupied_by)
      add_blank_spot(piece)
      move_results = rival_pieces.each_with_object([]) { |r_piece, r_arr| r_arr.push(piece_check(temp_board, r_piece)) }
      arr.push(move_results.any?(true))
    end
  end
end
