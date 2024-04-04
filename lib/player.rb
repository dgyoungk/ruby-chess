# frozen_string_literal: false

# './lib/player.rb'
class Player
  attr_accessor :name, :piece_color, :captured

  def initialize(name, piece_color = nil)
    self.name = name
    self.piece_color = piece_color
    self.captured = []
  end

  def designate_color(color)
    self.piece_color = color
  end

  def update_captured(piece)
    captured.push(piece)
  end

  def reset_captured
    self.captured = []
  end
end
