require_relative 'board'
require_relative 'player'
require './lib/modules/chess_logic.rb'

Dir["./lib/modules/*.rb"].each {|file| require file }

# './lib/game.rb'
class Game
  include ChessLogic

  attr_accessor :player1, :player2, :board, :game_finished, :turn, :replay

  def initialize
    self.player1 = nil
    self.player2 = nil
    self.board = Board.new
    self.game_finished = false
    self.turn = 1
    self.replay = true
  end

  def game_setup
    welcome_msg
    2.times { create_player }
    rules_msg
    info_msg
    start_game
  end

  def keep_playing?
    return replay
  end

  def create_player
    new_player_msg
    p_name = gets.chomp
    assign_player(p_name)
  end

  def assign_player(username)
    return unless player1.nil? || player2.nil?
    if player1.nil?
      self.player1 = Player.new(username)
    else
      self.player2 = Player.new(username)
    end
  end

  def start_game
    while keep_playing?
      play_once
      prompt_replay
      game_end
    end
  end

  def play_once

  end

  def prompt_replay
    replay_choice = user_decision
    self.replay = false if replay_choice == 'n'
  end

  def game_end
    keep_playing? ? game_reset : goodbye_msg
  end

  def game_reset
    self.game_finished = false
    self.turn = 1
  end
end
