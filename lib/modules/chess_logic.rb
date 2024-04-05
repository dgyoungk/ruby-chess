# frozen_string_literal: false

# namespace for all the modules that will be used
Dir['./lib/modules/*.rb'].sort.each { |file| require file unless file.include?('logic') }

# './lib/modules/chess_logic.rb'
module ChessLogic
  include BasicSerializable
  include Colorable
  include Displayable
  include Informable
  include Movable
  include Occupiable
  include Playable
  include Promptable
  include Retrievable
  include Thinkable
end
