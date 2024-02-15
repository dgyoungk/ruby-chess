require_relative 'chess_piece'

# './lib/game_pieces/rook.rb'
class Rook < ChessPiece
  def initialize(type, color)
    super(type, color)
    rook_moves
  end

  def rook_moves
    self.possible_moves = moves_of_rook
  end
end
