# './lib/spec/game_spec.rb'
require './lib/game.rb'
require './lib/board.rb'
require './lib/player.rb'
require './lib/game_pieces/chess_piece.rb'
require './lib/modules/chess_logic.rb'

describe Game do
  # include ChessLogic
  subject(:dummy) { described_class.new }
  let(:p1) { double('player1', name: 'joe', piece_color: 'white') }
  let(:p2) { double('player2', name: 'beck', piece_color: 'black') }
  describe '#create_player' do
    let(:count) { 0 }
    let(:player_name) { 'joe' }
    let(:harry) { double('harry', name: 'joe') }
    context 'when method is called' do
      before do
        allow(dummy).to receive(:player_info_msg)
        allow(dummy).to receive(:new_player_msg).with(count)
        allow(dummy).to receive(:blank_name_msg)
        # allow(dummy).to receive(:player_created_msg).with harry, dummy.alt_colors
      end
      it 'triggers #refine_name' do
        expect(dummy).to receive(:refine_name).with(count).and_return player_name
        dummy.create_player(count)
      end
      it 'triggers #store_new_player' do
        allow(dummy).to receive(:refine_name).with(count).and_return player_name
        expect(dummy).to receive(:store_new_player).with(player_name)
        dummy.create_player(count)
      end
    end
  end

  describe '#store_new_player' do
    let(:lloyd) { double('lloyd', name: 'lloyd') }
    # before do
    #   allow(dummy).to receive(:player_created_msg).with(lloyd, dummy.alt_colors)
    # end
    context 'after method execution' do
      it 'stores a Player object in the players array' do
        dummy.store_new_player(lloyd.name)
        expect(dummy.players).not_to be_empty
      end
    end
  end

  describe '#start_game' do
    context 'when replay attr is false' do
      before do
        dummy.instance_variable_set(:@replay, false)
      end
      it 'does not trigger #play_once' do
        expect(dummy).not_to receive(:play_once)
        dummy.start_game
      end
      it 'does not trigger #prompt_replay' do
        expect(dummy).not_to receive(:prompt_replay)
        dummy.start_game
      end
      it 'does not trigger #game_end' do
        expect(dummy).not_to receive(:game_end)
        dummy.start_game
      end
    end
  end

  describe '#play_once' do
    let(:turn) { 1 }
    # let(:p1) { double('player1', name: 'joe', piece_color: 'white') }
    # let(:p2) { double('player2', name: 'beck', piece_color: 'black') }
    before do
      allow(dummy).to receive(:moving_info_msg)
      allow(dummy).to receive(:turn_msg).with(turn)
    end
    context 'when the game_finished attr is true' do
      before do
        dummy.instance_variable_set(:@game_finished, true)
      end
      it 'does not trigger #game_draw_status' do
        expect(dummy).not_to receive(:game_draw_status).with(p1)
        dummy.play_once
      end
      it 'does not display the chess board' do
        expect(dummy).not_to receive(:show_chess_board).with(dummy.board)
        dummy.play_once
      end
      it 'does not trigger #move_piece' do
        expect(dummy).not_to receive(:move_piece).with(p1, turn, dummy.board, p2)
        dummy.play_once
      end
      it 'does not trigger #check_game_status' do
        expect(dummy).not_to receive(:check_game_status).with(p1, p2)
        dummy.play_once
      end
    end
  end

  describe '#check_game_status' do
    # let(:p1) { double('player1', name: 'joe', piece_color: 'white') }
    # let(:p2) { double('player2', name: 'beck', piece_color: 'black') }
    context 'when method executes' do
      before do
        allow(dummy).to receive(:winner_msg).with(p1.name)
        allow(dummy).to receive(:chess_check_msg).with(p1, p2, dummy.alt_colors)
        allow(dummy).to receive(:show_chess_board).with(dummy.board)
      end
      it 'triggers #checkmate?' do
        expect(dummy).to receive(:checkmate?).with(dummy.board, p1, p2)
        dummy.check_game_status(p1, p2)
      end
      it 'triggers #check?' do
        allow(dummy).to receive(:checkmate?).with(dummy.board, p1, p2).and_return false
        expect(dummy).to receive(:check?).with(dummy.board, p1)
        dummy.check_game_status(p1, p2)
      end
    end
    context 'when #checkmate? return true' do
      before do
        allow(dummy).to receive(:checkmate?).with(dummy.board, p1, p2).and_return true
      end
      it 'the winner is declared' do
        allow(dummy).to receive(:show_chess_board).with(dummy.board)
        expect(dummy).to receive(:winner_msg).with(p1.name)
        dummy.check_game_status(p1, p2)
      end
      it 'the chess board is displayed' do
        allow(dummy).to receive(:winner_msg).with(p1.name)
        expect(dummy).to receive(:show_chess_board).with(dummy.board)
        dummy.check_game_status(p1, p2)
      end
    end
    context 'when #check? returns true' do
      before do
        allow(dummy).to receive(:checkmate?).with(dummy.board, p1, p2).and_return false
        allow(dummy).to receive(:check?).with(dummy.board, p1).and_return true
      end
      it 'displays the game check message' do
        expect(dummy).to receive(:chess_check_msg).with(p1, p2, dummy.alt_colors)
        dummy.check_game_status(p1, p2)
      end
    end
  end

  describe '#checkmate?' do
    context 'when #check? and #stalemate? both return true' do
      before do
        allow(dummy).to receive(:check?).with(dummy.board, p1).and_return true
        allow(dummy).to receive(:stalemate?).with(dummy.board, p2).and_return true
      end
      it 'returns true' do
        result = dummy.checkmate?(dummy.board, p1, p2)
        expect(result).to be true
      end
    end
    context 'when #check? returns false' do
      before do
        allow(dummy).to receive(:check?).with(dummy.board, p1).and_return false
      end
      it '#stalemate? is not triggered' do
        expect(dummy).not_to receive(:stalemate?).with(dummy.board, p2)
        dummy.checkmate?(dummy.board, p1, p2)
      end
    end
  end

  describe '#game_draw_status' do
    context 'when #stalemate? and dead_position? return false' do
      before do
        allow(dummy).to receive(:stalemate?).with(dummy.board, p1).and_return false
        allow(dummy).to receive(:dead_position?).with(dummy.board).and_return false
      end
      it 'the chess board is not displayed' do
        expect(dummy).not_to receive(:show_chess_board).with(dummy.board)
        dummy.game_draw_status(p1)
      end
      it 'the draw message is not displayed' do
        expect(dummy).not_to receive(:stalemate_msg)
        dummy.game_draw_status(p1)
      end
    end
    context 'when either #stalemate? or dead_position? return true' do
      before do
        allow(dummy).to receive(:dead_position?).with(dummy.board).and_return true
        allow(dummy).to receive(:stalemate_msg)
        allow(dummy).to receive(:show_chess_board).with(dummy.board)
      end
      it 'displays the chess board' do
        expect(dummy).to receive(:show_chess_board).with(dummy.board)
        dummy.game_draw_status(p1)
      end
      it 'displays the draw message' do
        expect(dummy).to receive(:stalemate_msg)
        dummy.game_draw_status(p1)
      end
    end
  end
end
