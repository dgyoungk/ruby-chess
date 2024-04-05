# frozen_string_literal: false

# './lib/modules/displayable.rb'
module Displayable
  def show_chess_board(board)
    colors = chess_board_colors
    show_top_border
    board.squares.each do |coords, node|
      print_odd_row(coords, node, colors) if coords.first.odd?
      print_even_row(coords, node, colors) if coords.first.even?
    end
  end

  def print_odd_row(coords, node, colors)
    if coords.last.even?
      print_square(colors[:black], node, coords)
    else
      print_square(colors[:white], node, coords)
    end
  end

  def print_even_row(coords, node, colors)
    if coords.last.even?
      print_square(colors[:white], node, coords)
    else
      print_square(colors[:black], node, coords)
    end
  end

  def print_square(square_color, node, coords)
    if coords.last.eql?(8)
      puts bg_colorize(node.occupied_by.visual, square_color)
    elsif coords.last.eql?(1)
      print %(#{coords.first}\s\s\s#{bg_colorize(node.occupied_by.visual, square_color)})
    else
      print bg_colorize(node.occupied_by.visual, square_color)
    end
  end

  def show_top_border
    print "\n----------------------------\n"
    8.times do |n|
      if (n + 1).eql?(1)
        print %(\s\s\s\s\s#{n + 1}\s)
      elsif (n + 1).eql?(8)
        print %(\s#{n + 1}\s\n\n)
      else
        print %(\s#{n + 1}\s)
      end
    end
  end

  def welcome_msg
    puts %(\t\tRuby Chess\nOutsmart your opponents and show your wits!)
  end

  def player_info_msg
    puts %(\nOnly use letters, numbers, and underscores for your username)
  end

  def new_player_msg(count)
    print %(Player #{count + 1} username: )
  end

  def blank_name_msg
    puts %(Not a valid username, try again)
  end

  def player_created_msg(player, alt_colors)
    puts %(New player created: #{player.name}, piece color: #{alt_colors[player.piece_color]})
  end

  def rules_msg
    puts %(\nThe rules are pretty straight forward:)
    puts %(Corner the opponent's king piece to get a checkmate!)
    puts %(All pieces except the Knight piece cannot move over other pieces)
    puts %(You can only move one piece per turn)
  end

  def moving_info_msg
    puts %(\nTo move a piece, use this notation: (initial, row/column), (destination row, column))
    puts %(e.g. p74, 54 to move a pawn at [7,4] to [5, 4])
    puts %(Piece inital list: King: K, Queen: Q, Bishop: B, Rook: R, Knight: N, Pawn: p)
  end

  def turn_msg(count)
    puts %(\n\t\tTurn #{count}:)
  end

  def move_msg(player, alt_colors)
    print %(#{alt_colors[player.piece_color]}'s move: )
  end

  def error_msg
    puts %(\nInvalid option, try again)
  end

  def incorrect_piece_msg
    puts %(\nNo player piece at specified location, try again)
  end

  def illegal_move_msg
    puts %(Not a valid move, try again)
  end

  def blocked_path_msg
    puts %(A piece is blocking the path, try another position)
  end

  def check_move_msg
    puts %(That move would put your King in check, try another move)
  end

  def square_occupied_msg
    puts %(That square is already occupied, try another position)
  end

  def chess_check_msg(player, other_player, alt_colors)
    puts %(\n#{alt_colors[player.piece_color]} declares check on #{alt_colors[other_player.piece_color]}'s King)
  end

  def winner_msg(name)
    puts %(\nCheckmate, #{name} wins!!!)
  end

  def stalemate_msg
    puts %(\nThe game has come to a stalemate, it's a draw)
  end

  def replay_msg
    print %(\nWould you like to play again? (y/n): )
  end

  def goodbye_msg
    puts %(\nThanks for playing, till next time!)
  end

  def continuation_msg
    print %(Continue playing? (y/n): )
  end

  def game_save_msg
    print %(Would you like to save the game? (y/n): )
  end

  def open_game_msg
    print %(There's a saved game available, load the game? (y/n): )
  end

  def saved_msg
    puts %(Game saved!)
  end
end
