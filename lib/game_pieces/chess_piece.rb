require './lib/modules/retrievable.rb'

# './lib/game_pieces/chess_piece.rb'
class ChessPiece
  include Retrievable

  attr_accessor :possible_moves, :type, :color

  def initialize(possible_moves = [], type, color)
    self.possible_moves = possible_moves
    self.type = type
    self.color = color
  end

end
