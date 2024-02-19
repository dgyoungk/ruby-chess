Dir["./lib/game_pieces/*.rb"].each {|file| require file }

# './lib/modules/occupiable.rb'
module Occupiable
  def add_blank_spot(node)
    blank_piece = ChessPiece.new('placeholder', 'none', 'blankspot')
    blank_piece.add_visual(empty_square)
    node.add_occupancy(blank_piece)
  end

  def add_pawns(coords, node, color)
    new_pawn = Pawn.new('pawn', color, %(#{color}pawn#{coords.last}))
    node.add_occupancy(new_pawn)
  end

  def add_ranked_pieces(coords, node, color)
    case coords.last
    when 1, 8
      add_rook(coords, node, color)
    when 2, 7
      add_knight(coords, node, color)
    when 3, 6
      add_bishop(coords, node, color)
    when 4
      add_queen(coords, node, color)
    when 5
      add_king(coords, node, color)
    end
  end

  def add_rook(coords, node, color)
    new_rook = Rook.new('rook', color, %(#{color}rook#{coords.last}))
    node.add_occupancy(new_rook)
  end

  def add_knight(coords, node, color)
    new_knight = Knight.new('knight', color, %(#{color}knight#{coords.last}))
    node.add_occupancy(new_knight)
  end

  def add_bishop(coords, node, color)
    new_bishop = Bishop.new('bishop', color, %(#{color}bishop#{coords.last}))
    node.add_occupancy(new_bishop)
  end

  def add_queen(coords, node, color)
    new_queen = Queen.new('queen', color, %(#{color}queen#{coords.last}))
    node.add_occupancy(new_queen)
  end

  def add_king(coords, node, color)
    new_king = King.new('king', color, %(#{color}king#{coords.last}))
    node.add_occupancy(new_king)
  end
end
