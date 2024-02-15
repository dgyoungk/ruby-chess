require './lib/modules/retrievable.rb'
require_relative 'node'
# './lib/board.rb'
class Board
  include Retrievable

  attr_accessor :squares
  attr_reader :coordinates, :possible_edges

  def initialize
    self.squares = {}
    @coordinates = board_coordinates
    @possible_edges = board_edges
  end

  def create_board
    coordinates.each do |pair|
      new_square = Node.new(pair)
      add_square(new_square)
    end
  end

  def add_square(new_square)
    squares[new_square.coords] = new_square
  end

  def attach_board_edges
    squares.each do |coord, node|
      possible_edges.each do |pair|
        unless squares[[coord.first + pair.first, coord.last + pair.last]].nil?
          add_edge(coord, [coord.first + pair.first, coord.last + pair.last])
        end
      end
    end
  end

  def add_edge(node1, node2)
    squares[node1].add_neighbour(squares[node2])
    squares[node2].add_neighbour(squares[node1])
  end

end
