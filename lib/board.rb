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
    @coordinates.each do |pair|
      new_square = Node.new(pair)
      add_square(new_square)
    end
  end

  def add_square(new_square)
    squares[new_square.coords] = new_square
  end

end
