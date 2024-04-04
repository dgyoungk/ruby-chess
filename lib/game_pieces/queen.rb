# frozen_string_literal: false

require_relative 'chess_piece'

# './lib/game_pieces/queen.rb'
class Queen < ChessPiece
  def initialize(type, color)
    super(type, color)
    queen_moves
    assign_icon
  end

  def queen_moves
    @possible_moves = moves_of_bishop + moves_of_rook
  end

  def assign_icon
    self.visual = if color.eql?('black')
                    black_chess_pieces[type + color]
                  else
                    white_chess_pieces[type + color]
                  end
  end
end
