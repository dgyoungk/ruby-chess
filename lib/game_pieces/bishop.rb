# frozen_string_literal: false

require_relative 'chess_piece'

# './lib/game_pieces/bishop.rb'
class Bishop < ChessPiece
  def initialize(type, color)
    super(type, color)
    bishop_moves
    assign_icon
  end

  def bishop_moves
    @possible_moves = moves_of_bishop
  end

  def assign_icon
    self.visual = if color.eql?('black')
                    black_chess_pieces[type + color]
                  else
                    white_chess_pieces[type + color]
                  end
  end
end
