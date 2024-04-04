# frozen_string_literal: false

require_relative 'chess_piece'

# './lib/game_pieces/knight.rb'
class Knight < ChessPiece
  def initialize(type, color)
    super(type, color)
    knight_moves
    assign_icon
  end

  def knight_moves
    @possible_moves = moves_of_knight
  end

  def assign_icon
    self.visual = if color.eql?('black')
                    black_chess_pieces[type + color]
                  else
                    white_chess_pieces[type + color]
                  end
  end
end
