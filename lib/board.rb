require './lib/modules/retrievable.rb'
require './lib/modules/thinkable.rb'
require './lib/modules/displayable.rb'
require_relative 'node'

Dir["./lib/game_pieces/*.rb"].each {|file| require file }
# './lib/board.rb'
class Board
  include Retrievable
  include Thinkable
  include Displayable

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
      when 0
        add_ranked_pieces(coords, node, 'black')
      when 1
        add_pawns(coords, node, 'black')
      when 6
        add_pawns(coords, node, 'white')
      when 7
        add_ranked_pieces(coords, node, 'white')
      else
        add_blank_spot(node)
      end
    end
  end

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
    when 0, 7
      add_rook(coords, node, color)
    when 1, 6
      add_knight(coords, node, color)
    when 2, 5
      add_bishop(coords, node, color)
    when 3
      add_queen(coords, node, color)
    when 4
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
