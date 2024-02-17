# './lib/player.rb'
class Player
  attr_accessor :name, :player_color

  def initialize(name)
    self.name = name
  end

  def designate_color(color)
    self.player_color = color
  end
end
