# namespace for all the modules that will be used
require_relative 'displayable'
require_relative 'retrievable'
require_relative 'thinkable'
require_relative 'occupiable'

# './lib/modules/chess_logic.rb'
module ChessLogic
  include Displayable
  include Retrievable
  include Thinkable
  include Occupiable
end
