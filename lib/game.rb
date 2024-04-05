# frozen_string_literal: false

require_relative 'board'
require_relative 'player'
require './lib/modules/chess_logic'
require './lib/game_pieces/queen'

# './lib/game.rb'
class Game
  include ChessLogic

  @@save_path = './saves/game_file.txt'

  attr_accessor :board, :game_finished, :turn, :replay, :players

  attr_reader :player_colors, :alt_colors

  def initialize
    self.board = Board.new
    self.game_finished = false
    self.turn = 1
    self.replay = true
    self.players = []
    @player_colors = %w[white black]
    @alt_colors = { 'white' => 'Red', 'black' => 'Green' }
  end

  def game_setup
    welcome_msg
    create_save_dir
    prompt_game_load
  end

  def create_save_dir
    Dir.mkdir 'saves' unless Dir.exist? 'saves'
  end

  def prompt_game_load
    return unless File.exist?(@@save_path)

    choice = user_load
    choice.eql?('y') ? open_saved_game : new_game
  end

  def open_saved_game
    loaded_game = deserialize(load_saved_file(@@save_path))
    loaded_game.start_game(loaded_game)
  end

  def new_game
    2.times { |n| create_player(n) }
    rules_msg
    sleep 3
    start_game(self)
  end

  def start_game(match)
    while keep_playing?
      play_once(match)
      sleep 1
      prompt_replay if keep_playing?
      game_end
    end
  end

  private

  def play_once(match)
    until game_over?
      players.each do |player|
        other_player = opponent(player.piece_color, players)
        break if game_draw_status(player)

        make_move(player, other_player)
        break if check_game_status(player, other_player)

        sleep 1
      end
      self.turn += 1
      save_game(match) if prompt_save.eql?('y')
    end
  end

  def make_move(player, other_player)
    show_chess_board(board)
    moving_info_msg
    turn_msg(turn)
    move_piece(player, board, other_player)
  end

  def prompt_replay
    replay_choice = user_decision
    self.replay = false if replay_choice.eql?('n')
  end

  def game_end
    keep_playing? ? game_reset : goodbye_msg
  end

  def save_game(match)
    save_to_file(@@save_path, serialize(match))
    saved_msg
    continue = prompt_continuation
    cut_game_short if continue.eql?('n')
  end

  def cut_game_short
    self.game_finished = true
    self.replay = false
  end

  def game_draw_status(player)
    return unless stalemate?(board, player) || dead_position?(board)

    stalemate_msg
    show_chess_board(board)
    self.game_finished = true
  end

  def check_game_status(player, other_player)
    if checkmate?(board, player, other_player)
      winner_msg(player.name)
      show_chess_board(board)
      self.game_finished = true
    elsif check?(board, player)
      chess_check_msg(player, other_player, alt_colors)
    end
  end

  def game_reset
    self.game_finished = false
    self.turn = 1
    players.each(&:reset_captured)
    board.occupy_board
  end

  def keep_playing?
    replay
  end

  def game_over?
    game_finished
  end

  def create_player(count)
    p_name = refine_name(count)
    store_new_player(p_name, count)
  end

  def store_new_player(username, count)
    newcomer = Player.new(username)
    newcomer.designate_color(player_colors[count])
    players.push(newcomer)
    player_created_msg(newcomer, alt_colors)
    sleep 1
  end
end
