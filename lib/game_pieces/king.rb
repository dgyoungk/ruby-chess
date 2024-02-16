require_relative 'chess_piece'

# './lib/game_pieces/king.rb'
class King < ChessPiece

  def initialize(type, color, piece_id)
    super(type, color, piece_id)
    king_moves
    assign_icon
  end

  # since the king moves the same way the board squares are connected
  def king_moves
    self.possible_moves = board_edges
  end

  def assign_icon
    if color.eql?('black')
      self.visual = black_chess_pieces[self.type + self.color]
    else
      self.visual = white_chess_pieces[self.type + self.color]
    end
  end

end
