# './lib/modules/thinkable.rb'
module Thinkable
  # this method will change the background colors
  def bg_colorize(string, rgb_values)
    "\e[48;2;#{rgb_values}m#{string}\e[0m"
  end

  def fg_colorize(string, rgb_values)
    %(\e[38;2;#{rgb_values}m#{string}\u0020\e[0m)
  end

  def user_decision
    replay_msg
    decision = gets.chomp.downcase
    until decision_verified?(decision)
      error_msg
      replay_msg
      decision = gets.chomp.downcase
    end
    decision
  end

  def decision_verified?(p_choice)
    %w[y n].include?(p_choice)
  end
end
