require './lib/modules/retrievable.rb'

# './lib/game_pieces/chess_piece.rb'
class ChessPiece
  include Retrievable

  attr_accessor :possible_moves, :type, :color, :visual, :piece_id

  def initialize(possible_moves = [], type, color, piece_id)
    self.possible_moves = possible_moves
    self.piece_id = piece_id
    self.type = type
    self.color = color
    self.visual = nil
  end

end
