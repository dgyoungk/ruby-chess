require_relative 'colorable'
require_relative 'movable'
# './lib/modules/retrievable.rb'
module Retrievable
  include Colorable
  include Movable

  def board_edges
    return (-1..1).to_a.repeated_permutation(2).to_a.reject { |move| move.all? { |coord| coord.zero?} }
  end

  def board_coordinates
    return (1..8).to_a.repeated_permutation(2).to_a
  end

  def empty_square
    return "\s\s\s"
  end

  # Chess gameplay related methods
  def piece_initials
    initials = {
      'Q' => 'queen',
      'B' => 'bishop',
      'K' => 'king',
      'N' => 'knight',
      'R' => 'rook',
      'p' => 'pawn'
    }
  end

  def piece_type(move_notation)
    return piece_initials[move_notation.first.chars.first]
  end

  def piece_destination(move_notation)
    return move_notation.last.chars.map(&:to_i)
  end

  def piece_location(move_notation)
    return move_notation.first.chars[1..].map(&:to_i)
  end

  def selected_piece(player_pieces, move_notation)
    player_pieces.each do |spot|
      return spot if piece_matched?(move_notation, spot)
    end
  end

  def player_pieces(board, player)
    return board.squares.values.select { |spot| spot.occupied_by.color.eql?(player.piece_color) }
  end

  def legal_pawn_not(move_notation, moves, player, temp_piece)
    destination = piece_destination(move_notation)
    move_to_make = [destination.first - temp_piece.coords.first, destination.last - temp_piece.coords.last]
    until moves.include?(move_to_make)
      illegal_move_msg
      move_notation = piece_position(player).split(/,\s*/)
      new_dest = piece_destination(move_notation)
      move_to_make = [new_dest.first - temp_piece.coords.first, new_dest.last - temp_piece.coords.last]
    end
    move_notation
  end

  def create_count(difference, count = [])
    if difference.first.zero?
      count = [0, difference.last.negative? ? -1 : 1]
    elsif difference.last.zero?
      count = [difference.first.negative? ? -1 : 1, 0]
    else
      count.push(difference.first.negative? ? -1 : 1)
      count.push(difference.last.negative? ? -1 : 1)
    end
    count
  end

  def update_count(count)
    if count.first.zero?
      count[-1] = count.last.negative? ? count.last - 1 : count.last + 1
    elsif count.last.zero?
      count[0] = count.first.negative? ? count.first - 1 : count.first + 1
    else
      count = [count.first.negative? ? count.first - 1 : count.first + 1, count.last.negative? ? count.last - 1 : count.last + 1]
    end
    count
  end

  # Chess game winning condition related methods
  def pieces_on_board(board, player, piece)
    return player_pieces(board, player).select { |spot| spot.occupied_by.type.eql?(piece) }
  end

  def player_king_piece(player_pieces)
    return player_pieces.select { |spot| spot.occupied_by.type.eql?('king') }.pop
  end

  def opponent_pieces(other_pieces)
    other_color = other_pieces.reject do |spot|
      piece = spot.occupied_by
      piece.type.eql?('king') || piece.color.eql?('none')
    end
  end
end
