require_relative 'chess_piece'

# './lib/game_pieces/queen.rb'
class Queen < ChessPiece
  def initialize(type, color, piece_id)
    super(type, color, piece_id)
    queen_moves
    assign_icon
  end

  def queen_moves
    self.possible_moves = moves_of_bishop + moves_of_rook
  end

  def assign_icon
    if color.eql?('black')
      self.visual = black_chess_pieces[self.type + self.color]
    else
      self.visual = white_chess_pieces[self.type + self.color]
    end
  end
end
