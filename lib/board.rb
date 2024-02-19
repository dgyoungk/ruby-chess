require_relative 'node'
require './lib/modules/chess_logic.rb'

# './lib/board.rb'
class Board
  include ChessLogic

  attr_accessor :squares
  attr_reader :coordinates, :possible_edges

  def initialize
    self.squares = {}
    @coordinates = board_coordinates
    @possible_edges = board_edges
    create_board
    attach_board_edges
    clean_board_edges
    occupy_board
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

  def clean_board_edges
    squares.each { |coords, node| node.neighbours.uniq! }
  end

  def add_edge(node1, node2)
    squares[node1].add_neighbour(squares[node2])
    squares[node2].add_neighbour(squares[node1])
  end

  def occupy_board
    squares.each do |coords, node|
      case coords.first
      when 1
        add_ranked_pieces(coords, node, 'black')
      when 2
        add_pawns(coords, node, 'black')
      when 7
        add_pawns(coords, node, 'white')
      when 8
        add_ranked_pieces(coords, node, 'white')
      else
        add_blank_spot(node)
      end
    end
  end
end
