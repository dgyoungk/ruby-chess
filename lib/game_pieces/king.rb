require_relative 'chess_piece'

# './lib/game_pieces/king.rb'
class King < ChessPiece
  def initialize(type, color)
    super(type, color)
    king_moves
  end

  # since the king moves the same way the board squares are connected
  def king_moves
    self.possible_moves = board_edges
  end

end
