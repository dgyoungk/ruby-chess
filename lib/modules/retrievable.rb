require_relative 'thinkable'

# './lib/modules/retrievable.rb'
module Retrievable
  include Thinkable
  # the reject block removes the [0,0] move since it's redundant
  def board_edges
    return (-1..1).to_a.repeated_permutation(2).to_a.reject { |move| move.all? { |coord| coord.zero?} }
  end

  def board_coordinates
    return (1..8).to_a.repeated_permutation(2).to_a
  end

  def moves_of_knight
    base =  (-2..2).to_a.repeated_permutation(2).to_a
    return base.reject { |pair| pair.first.eql?(pair.last) || pair.include?(0) || pair.first.eql?(-(pair.last)) }
  end

  def moves_of_pawn
    return [[0, 1], [-1, 1], [1, 1], [0, 2]]
  end

  def moves_of_rook
    base = (-7..7).to_a.repeated_permutation(2).to_a.select do |pair|
      unless pair.first.eql?(pair.last)
        pair.first.zero? || pair.last.zero?
      end
    end
  end

  def moves_of_bishop
    base = (-7..7).to_a.repeated_permutation(2).to_a.select do |pair|
      unless pair.first.zero?
        pair.first.eql?(pair.last) || pair.first.eql?(-pair.last)
      end
    end
  end

  # method that houses all the unicode representation of the chess pieces
  def black_chess_pieces
    black_visuals = {
      'kingblack' => %(\s#{fg_colorize("\u265A", chess_board_colors[:green])}),
      'queenblack' => "\s#{fg_colorize("\u265B", chess_board_colors[:green])}",
      'rookblack' => "\s#{fg_colorize("\u265C", chess_board_colors[:green])}",
      'bishopblack' => "\s#{fg_colorize("\u265D", chess_board_colors[:green])}",
      'knightblack' => "\s#{fg_colorize("\u265E", chess_board_colors[:green])}",
      'pawnblack' => "\s#{fg_colorize("\u265F", chess_board_colors[:green])}"
    }
  end

  def white_chess_pieces
    white_visuals = {
      'kingwhite' => "\s#{fg_colorize("\u265A", chess_board_colors[:red])}",
      'queenwhite' => "\s#{fg_colorize("\u265B", chess_board_colors[:red])}",
      'rookwhite' => "\s#{fg_colorize("\u265C", chess_board_colors[:red])}",
      'bishopwhite' => "\s#{fg_colorize("\u265D", chess_board_colors[:red])}",
      'knightwhite' => "\s#{fg_colorize("\u265E", chess_board_colors[:red])}",
      'pawnwhite' => "\s#{fg_colorize("\u265F", chess_board_colors[:red])}"
    }
  end

  def chess_board_colors
    square_colors = {
      white: '255;255;255',
      black: '0;0;0',
      green: '0;255;0',
      red: '255;0;0'
    }
  end

  def piece_initials
    initials = {
      'Q' => 'queen',
      'K' => 'king',
      'N' => 'knight',
      'R' => 'rook',
      'p' => 'pawn'
    }
  end

  def empty_square
    return "\s\s\s"
  end
end
