require_relative 'chess_piece'

# './lib/game_pieces/knight.rb'
class Knight < ChessPiece

  def initialize(type, color, piece_id)
    super(type, color, piece_id)
    knight_moves
    assign_icon
  end

  def knight_moves
    self.possible_moves = moves_of_knight
  end

  def assign_icon
    if color.eql?('black')
      self.visual = black_chess_pieces[self.type + self.color]
    else
      self.visual = white_chess_pieces[self.type + self.color]
    end
  end
end
