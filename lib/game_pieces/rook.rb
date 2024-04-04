# frozen_string_literal: false

require_relative 'chess_piece'

# './lib/game_pieces/rook.rb'
class Rook < ChessPiece
  def initialize(type, color)
    super(type, color)
    rook_moves
    assign_icon
  end

  def rook_moves
    @possible_moves = moves_of_rook
  end

  def assign_icon
    self.visual = if color.eql?('black')
                    black_chess_pieces[type + color]
                  else
                    white_chess_pieces[type + color]
                  end
  end
end
