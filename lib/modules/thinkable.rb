# './lib/modules/thinkable.rb'
module Thinkable
  # this method will change the background colors
  def colorize(string, rgb_values)
    "\e[48;2;#{rgb_values}m#{string}\e[0m"
  end
end
