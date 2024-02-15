require_relative 'chess_piece'

# './lib/game_pieces/knight.rb'
class Knight < ChessPiece
  def initialize(type, color)
    super(type, color)
    knight_moves
  end

  def knight_moves
    self.possible_moves = moves_of_knight
  end
end
