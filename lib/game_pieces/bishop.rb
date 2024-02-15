require_relative 'chess_piece'

# './lib/game_pieces/bishop.rb'
class Bishop < ChessPiece
  def initialize(type, color)
    super(type, color)
    bishop_moves
  end

  def bishop_moves
    self.possible_moves = moves_of_bishop
  end
end
