# frozen_string_literal: false

# './lib/modules/colorable.rb'
module Colorable
  # method that houses all the unicode representation of the chess pieces
  def black_chess_pieces
    {
      'kingblack' => %(\s#{fg_colorize("\u265A", chess_board_colors[:green])}),
      'queenblack' => "\s#{fg_colorize("\u265B", chess_board_colors[:green])}",
      'rookblack' => "\s#{fg_colorize("\u265C", chess_board_colors[:green])}",
      'bishopblack' => "\s#{fg_colorize("\u265D", chess_board_colors[:green])}",
      'knightblack' => "\s#{fg_colorize("\u265E", chess_board_colors[:green])}",
      'pawnblack' => "\s#{fg_colorize("\u265F", chess_board_colors[:green])}"
    }
  end

  def white_chess_pieces
    {
      'kingwhite' => "\s#{fg_colorize("\u265A", chess_board_colors[:red])}",
      'queenwhite' => "\s#{fg_colorize("\u265B", chess_board_colors[:red])}",
      'rookwhite' => "\s#{fg_colorize("\u265C", chess_board_colors[:red])}",
      'bishopwhite' => "\s#{fg_colorize("\u265D", chess_board_colors[:red])}",
      'knightwhite' => "\s#{fg_colorize("\u265E", chess_board_colors[:red])}",
      'pawnwhite' => "\s#{fg_colorize("\u265F", chess_board_colors[:red])}"
    }
  end

  # this method will change the background colors
  def bg_colorize(string, rgb_values)
    "\e[48;2;#{rgb_values}m#{string}\e[0m"
  end

  def fg_colorize(string, rgb_values)
    %(\e[38;2;#{rgb_values}m#{string}\u0020\e[0m)
  end

  def chess_board_colors
    {
      white: '255;255;255',
      black: '0;0;0',
      green: '0;255;0',
      red: '255;0;0'
    }
  end
end
