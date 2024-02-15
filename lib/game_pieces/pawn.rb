require_relative 'chess_piece'

# './lib/game_pieces/pawn.rb'
class Pawn < ChessPiece
  def initialize(type, color)
    super(type, color)
    pawn_moves
  end

  def pawn_moves
    self.possible_moves = moves_of_pawn
  end
end
