# frozen_string_literal: false

# namespace for all the modules that will be used
Dir['./lib/modules/*.rb'].sort.each { |file| require file unless file.include?('logic') }

# './lib/modules/chess_logic.rb'
module ChessLogic
  include Displayable
  include Retrievable
  include Informable
  include Occupiable
  include Playable
  include BasicSerializable
  include Promptable
end
