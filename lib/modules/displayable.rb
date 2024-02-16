require_relative 'retrievable'
require_relative 'thinkable'

# './lib/modules/displayable.rb'
module Displayable
  def show_chess_board(board)
    colors = chess_board_colors
    board.squares.each_with_index do |(coords, node), idx|
      # if index is odd then display a black background
      # if index is even then display a white background
      if idx.even?
        print_square(colors[:white], node, idx)
      elsif idx.odd?
        print_square(colors[:black], node, idx)
      end
    end
  end

  def print_square(square_color, node, idx)
    if idx.zero? || (idx % 7).eql?(1)
      print %(|#{colorize(node.occupied_by.visual, square_color)}|)
    elsif (idx % 7 ).zero?
      print %(#{colorize(node.occupied_by.visual, square_color)}|\n)
    else
      print %(#{colorize(node.occupied_by.visual, square_color)}|)
    end
  end
end
