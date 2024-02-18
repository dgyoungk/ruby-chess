# './lib/player.rb'
class Player
  attr_accessor :name, :piece_color, :captured

  def initialize(name)
    self.name = name
  end

  def designate_color(color)
    self.piece_color = color
  end

  def update_captured(piece)
    self.captured.push(piece)
  end
end
