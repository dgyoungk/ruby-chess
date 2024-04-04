# frozen_string_literal: false

require './lib/modules/retrievable'

# './lib/game_pieces/chess_piece.rb'
class ChessPiece
  include Retrievable

  attr_accessor :type, :color, :visual
  attr_reader :possible_moves

  def initialize(type, color, possible_moves = [])
    @possible_moves = possible_moves
    self.type = type
    self.color = color
    self.visual = nil
  end

  def add_visual(visual_str)
    self.visual = visual_str
  end
end
