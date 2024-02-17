require './lib/modules/retrievable'
require './lib/modules/thinkable'

# './lib/modules/displayable.rb'
module Displayable
  include Retrievable
  include Thinkable

  def show_chess_board(board)
    colors = chess_board_colors
    show_top_border
    board.squares.each do |coords, node|
      # if index is odd then display a black background
      # if index is even then display a white background
      print_row(coords, node, colors)
    end
    show_bottom_border
  end

  def print_row(coords, node, colors)
    if (coords.first).even?
      if (coords.last).even?
        print_square(colors[:white], node, coords)
      else
        print_square(colors[:black], node, coords)
      end
    elsif (coords.first).odd?
      if (coords.last).even?
        print_square(colors[:black], node, coords)
      else
        print_square(colors[:white], node, coords)
      end
    end
  end

  def print_square(square_color, node, coords)
    if (coords.last).eql?(7)
      puts %(#{bg_colorize(node.occupied_by.visual, square_color)})
    else
      print %(#{bg_colorize(node.occupied_by.visual, square_color)})
    end
  end

  def show_top_border
    24.times { print "\u{1FB7B}" }
    puts
  end

  def show_bottom_border
    24.times { print "\u{1FB76}" }
    puts
  end

  def welcome_msg

  end

  def rules_msg

  end

  # method to get the chess piece the player wants to move
  def piece_msg

  end
  # method to get the coords the player wants to move the piece to
  def move_piece_msg

  end

  def error_msg

  end


end
