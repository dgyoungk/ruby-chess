# './lib/modules/retrievable.rb'
module Retrievable
  # the reject block removes the [0,0] move since it's redundant
  def board_edges
    return (-1..1).to_a.repeated_permutation(2).to_a.reject { |move| move.all? { |coord| coord.zero?} }
  end

  def board_coordinates
    return (0..7).to_a.repeated_permutation(2).to_a
  end

  def moves_of_knight
    base =  (-2..2).to_a.repeated_permutation(2).to_a
    return base.reject { |pair| pair.first.eql?(pair.last) || pair.include?(0) || pair.first.eql?(-(pair.last)) }
  end

  def moves_of_pawn
    return [[0, 1], [-1, 1], [1, 1]]
  end

  def moves_of_rook
    base = (-6..6).to_a.repeated_permutation(2).to_a.select do |pair|
      unless pair.first.eql?(pair.last)
        pair.first.zero? || pair.last.zero?
      end
    end
  end

  def moves_of_bishop
    base = (-6..6).to_a.repeated_permutation(2).to_a.select do |pair|
      unless pair.first.zero?
        pair.first.eql?(pair.last) || pair.first.eql?(-pair.last)
      end
    end
  end
end
