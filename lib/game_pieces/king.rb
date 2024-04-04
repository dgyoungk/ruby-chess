# frozen_string_literal: false

require_relative 'chess_piece'

# './lib/game_pieces/king.rb'
class King < ChessPiece
  def initialize(type, color)
    super(type, color)
    king_moves
    assign_icon
  end

  # since the king moves the same way the board squares are connected
  def king_moves
    @possible_moves = board_edges
  end

  def assign_icon
    self.visual = if color.eql?('black')
                    black_chess_pieces[type + color]
                  else
                    white_chess_pieces[type + color]
                  end
  end
end
