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
    if color.eql?('black')
      self.visual = black_chess_pieces[self.type + self.color]
    else
      self.visual = white_chess_pieces[self.type + self.color]
    end
  end
end
