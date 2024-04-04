# frozen_string_literal: false

# namespace for all the modules that will be used
require_relative 'displayable'
require_relative 'retrievable'
require_relative 'informable'
require_relative 'occupiable'
require_relative 'playable'

# './lib/modules/chess_logic.rb'
module ChessLogic
  include Displayable
  include Retrievable
  include Informable
  include Occupiable
  include Playable
end
