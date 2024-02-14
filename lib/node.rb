# './lib/node.rb'
class Node
  attr_accessor :coords, :neighbours, :occupied_by
  def initialize(coords)
    self.coords = coords
    self.neighbours = []
    self.occupied_by = nil
  end

  def add_neighbour(adjacent)
    self.neighbours << adjacent
  end

  def add_occupancy(chess_piece)
    self.occupied_by = chess_piece
  end
end
