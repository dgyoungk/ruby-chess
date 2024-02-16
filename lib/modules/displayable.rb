require_relative 'retrievable'
require_relative 'thinkable'

# './lib/modules/displayable.rb'
module Displayable
  def show_chess_board(board)
    board.squares.each_with_index do |(coords, node), idx|
      if idx.odd? && idx % 7 != 1
        print %(#{node.occupied_by.visual})
      else

      end
    end
  end
end
