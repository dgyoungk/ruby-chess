# './lib/modules/retrievable.rb'
module Retrievable
  # the reject block removes the [0,0] move since it's redundant
  def board_edges
    return (-1..1).to_a.repeated_permutation(2).to_a.reject { |move| move.all? { |coord| coord.zero?} }
  end

  def board_coordinates
    return (0..7).to_a.repeated_permutation(2).to_a
  end
end
