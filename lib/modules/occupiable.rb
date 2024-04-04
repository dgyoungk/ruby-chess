# frozen_string_literal: false

Dir['./lib/game_pieces/*.rb'].sort.each { |file| require file }

# './lib/modules/occupiable.rb'
module Occupiable
  def add_blank_spot(node)
    blank_piece = ChessPiece.new('placeholder', 'none')
    blank_piece.add_visual(empty_square)
    node.add_occupancy(blank_piece)
  end

  def add_pawns(node, color)
    new_pawn = Pawn.new('pawn', color)
    node.add_occupancy(new_pawn)
  end

  def add_ranked_pieces(coords, node, color)
    case coords.last
    when 1, 8
      add_rook(node, color)
    when 2, 7
      add_knight(node, color)
    when 3, 6
      add_bishop(node, color)
    when 4
      add_queen(node, color)
    when 5
      add_king(node, color)
    end
  end

  def add_rook(node, color)
    new_rook = Rook.new('rook', color)
    node.add_occupancy(new_rook)
  end

  def add_knight(node, color)
    new_knight = Knight.new('knight', color)
    node.add_occupancy(new_knight)
  end

  def add_bishop(node, color)
    new_bishop = Bishop.new('bishop', color)
    node.add_occupancy(new_bishop)
  end

  def add_queen(node, color)
    new_queen = Queen.new('queen', color)
    node.add_occupancy(new_queen)
  end

  def add_king(node, color)
    new_king = King.new('king', color)
    node.add_occupancy(new_king)
  end
end
