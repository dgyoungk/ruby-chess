require './lib/modules/retrievable.rb'

# './lib/game_pieces/chess_piece.rb'
class ChessPiece
  include Retrievable

  attr_accessor :possible_moves, :type, :color, :visual

  def initialize(possible_moves = [], type, color)
    self.possible_moves = possible_moves
    self.type = type
    self.color = color
    self.visual = nil
  end

  def add_visual(visual_str)
    self.visual = visual_str
  end

end
