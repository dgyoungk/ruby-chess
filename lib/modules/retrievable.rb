# frozen_string_literal: false

require_relative 'colorable'
require_relative 'movable'
# './lib/modules/retrievable.rb'
module Retrievable
  include Colorable
  include Movable

  def board_edges
    (-1..1).to_a.repeated_permutation(2).to_a.reject { |move| move.all?(&:zero?) }
  end

  def board_coordinates
    (1..8).to_a.repeated_permutation(2).to_a
  end

  def empty_square
    "\s\s\s"
  end

  # Chess gameplay related methods
  def piece_initials
    {
      'Q' => 'queen',
      'B' => 'bishop',
      'K' => 'king',
      'N' => 'knight',
      'R' => 'rook',
      'p' => 'pawn'
    }
  end

  def opponent(piece_color, players)
    return players.last if piece_color.eql?('white')

    players.first
  end

  def piece_type(move_notation)
    piece_initials[move_notation.first.chars.first]
  end

  def piece_destination(move_notation)
    move_notation.last.chars.map(&:to_i)
  end

  def piece_location(move_notation)
    move_notation.first.chars[1..].map(&:to_i)
  end

  def selected_piece(player_pieces, move_notation)
    player_pieces.each do |spot|
      return spot if piece_matched?(move_notation, spot)
    end
  end

  def player_pieces(board, player)
    board.squares.values.select { |spot| spot.occupied_by.color.eql?(player.piece_color) }
  end

  def other_pieces(board, player)
    board.squares.values.reject { |spot| spot.occupied_by.color.eql?(player.piece_color) }
  end

  def legal_pawn_not(move_notation, moves, player, temp_piece)
    destination = piece_destination(move_notation)
    move_to_make = create_move(destination, temp_piece.coords)
    until moves.include?(move_to_make)
      illegal_move_msg
      move_notation = piece_position(player, alt_colors).split(/,\s*/)
      new_dest = piece_destination(move_notation)
      move_to_make = create_move(new_dest, temp_piece.coords)
    end
    move_notation
  end

  def create_move(destination, current, move = [])
    move.push(destination.first - current.first)
    move.push(destination.last - current.last)
    move
  end

  def create_destination(current, move, dest = [])
    dest.push(current.first + move.first)
    dest.push(current.last + move.last)
    dest
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

  def new_coord(coord, updated = 0)
    if coord.negative?
      updated = coord - 1
    else
      updated = coord + 1
    end
    updated
  end

  def updated_diff(coord, updated = 0)
    if coord.negative?
      updated = coord + 1
    else
      updated = coord - 1
    end
    updated
  end

  def update_count(count)
    if count.first.zero?
      count[-1] = new_coord(count.last)
    elsif count.last.zero?
      count[0] = new_coord(count.first)
    else
      count = [new_coord(count.first), new_coord(count.last)]
    end
    count
  end

  def update_difference(difference, new_diff = Array.new(2))
    if difference.first.zero?
      new_diff[0] = difference.first
      new_diff[-1] = updated_diff(difference.last)
    elsif difference.last.zero?
      new_diff[-1] = difference.last
      new_diff[0] = updated_diff(difference.first)
    else
      new_diff = [updated_diff(difference.first), updated_diff(difference.last)]
    end
    new_diff
  end

  # Chess game winning condition related methods
  def pieces_on_board(board, player, piece)
    player_pieces(board, player).select { |spot| spot.occupied_by.type.eql?(piece) }
  end

  def player_king_piece(player_pieces)
    player_pieces.select { |spot| spot.occupied_by.type.eql?('king') }.pop
  end

  def opponent_pieces(other_pieces)
    other_pieces.reject do |spot|
      piece = spot.occupied_by
      piece.type.eql?('king') || piece.color.eql?('none')
    end
  end

  def object_copy(obj)
    Marshal.load(Marshal.dump(obj))
  end
end
