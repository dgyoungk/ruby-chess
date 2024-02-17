# './lib/modules/displayable.rb'
module Displayable
  def show_chess_board(board)
    colors = chess_board_colors
    show_top_border
    board.squares.each do |coords, node|
      print_odd_row(coords, node, colors) if (coords.first).odd?
      print_even_row(coords, node, colors) if (coords.first).even?
    end
    show_bottom_border
  end

  def print_odd_row(coords, node, colors)
    if (coords.last).even?
      print_square(colors[:black], node, coords)
    else
      print_square(colors[:white], node, coords)
    end
  end

  def print_even_row(coords, node, colors)
    if (coords.last).even?
      print_square(colors[:white], node, coords)
    else
      print_square(colors[:black], node, coords)
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

  def new_player_msg
    print %(\nPlayer username: )
  end

  def rules_msg

  end

  def info_msg
    puts %(Since the pieces are colored red and green)
    puts %(Red will be white, and black will be green)
  end

  def turn_msg(name)
    puts %(\nIt's #{name}'s turn)
  end

  # method to get the chess piece the player wants to move
  def piece_msg

  end
  # method to get the coords the player wants to move the piece to
  def move_piece_msg

  end

  def winner_msg(name)
    puts %(\n#{name} wins!!!)
  end

  def error_msg
    puts %(\nInvalid option, try again)
  end

  def replay_msg
    print %(\nWould you like to play again? (y/n): )
  end

  def goodbye_msg
    puts %(\nThanks for playing, till next time!)
  end
end
