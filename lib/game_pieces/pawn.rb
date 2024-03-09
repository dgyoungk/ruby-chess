require_relative 'chess_piece'

# './lib/game_pieces/pawn.rb'
class Pawn < ChessPiece

  def initialize(type, color)
    super(type, color)
    pawn_moves
    assign_icon
  end

  def pawn_moves
    @possible_moves = moves_of_pawn
  end

  def assign_icon
    if color.eql?('black')
      self.visual = black_chess_pieces[self.type + self.color]
    else
      self.visual = white_chess_pieces[self.type + self.color]
    end
  end
end
