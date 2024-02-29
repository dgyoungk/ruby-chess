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
    if (coords.last).eql?(8)
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
    puts %(\t\tRuby Chess\nOutsmart your opponents and show your wits!)
  end

  def new_player_msg(count)
    print %(\nPlayer #{count + 1} username: )
  end

  def player_created_msg(player)
    puts %(New player created: #{player.name}, piece color: #{player.piece_color})
  end

  def rules_msg
    puts %(\nThe rules are pretty straight forward:)
    puts %(Corner the opponent's king piece to get a checkmate!)
    puts %(All pieces except the Knight piece cannot move over other pieces)
    puts %(You can only move one piece per turn)
  end

  def info_msg
    puts %(\nSince the pieces are colored red and green)
    puts %(Red will be white, and black will be green)
    puts %()
  end

  def moving_info_msg
    puts %(\nTo move a piece, use the following notation: (piece initial, current column), (destination row/column))
    puts %(e.g. Q3, 54 to move a queen piece at column 3 to [5, 4]; p2, 34 to move a pawn at column 2 to [3, 4])
    puts %(Piece inital list: King: K, Queen: Q, Bishop: B, Rook: R, Knight: N, Pawn: p)
    puts %(The squares are ordered 1-8, left-to-right, top-to-bottom)
  end

  def turn_msg(count)
    puts %(\n\t\tTurn #{count}:)
  end

  # method to get the coords the player wants to move the piece to
  def move_msg(player)
    print %(#{player.name}'s move: )
  end

  def invalid_move_msg
    puts %(Not a valid move, try again)
  end

  def chess_check_msg(player)
    puts %(\n#{player.name} declares check on the King)
  end

  def winner_msg(name)
    puts %(\nCheckmate, #{name} wins!!!)
  end

  def no_winner_msg
    puts %(\nThe game has come to a draw)
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
