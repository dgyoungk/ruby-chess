require_relative 'chess_piece'

# './lib/game_pieces/queen.rb'
class Queen < ChessPiece
  def initialize(type, color)
    super(type, color)
    queen_moves
  end

  def queen_moves
    self.possible_moves = moves_of_bishop + moves_of_rook
  end
end
