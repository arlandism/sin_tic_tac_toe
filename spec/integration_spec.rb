require 'rack/test'
require_relative '../app'

describe "integration tests" do

  include Rack::Test::Methods

  def app
    TTTDuet.new
  end

  before(:each) do
    ClientSocket.any_instance.stub(:connect!) 
  end

  describe "integration with service" do

    let(:game_info) { double(:game_info) }

    before(:each) do
      GameRecorder.stub(:write_move)
      GameRecorder.stub(:write_winner)
      GameInformation.stub(:new).and_return(game_info)
    end

    it "hands the game state and configurations to AI" do
      rack_mock_session.cookie_jar["depth"] = 10
      rack_mock_session.cookie_jar["winner"] = nil
      move = 6
      token = "x"
      current_board_state = {move.to_s => token,
                             "depth" => "10",
                             "winner" => ""}

      game_info.stub(:winner_on_board).and_return("x")
      NextPlayer.should_receive(:move).once.with(current_board_state)

      post '/move', {:player_move => move}
    end
  end

  describe "integration with GameRecorder" do

    let(:id) { 24 }

    before(:each) do
      rack_mock_session.cookie_jar["id"] = id
    end

    it "delegates moves to GameRecorder" do
      NextPlayer.stub(:move).and_return(4)
      GameInformation.any_instance.stub(:winner_on_board).and_return("x")

      GameRecorder.should_receive(:write_move).once.with(id,4,"o")
      GameRecorder.should_receive(:write_move).once.with(id,34,"x")

      post '/move', {:player_move => 34}
    end

    it "delegates winners to GameRecorder" do
      NextPlayer.stub(:move)
      GameRecorder.stub(:write_move)
      GameInformation.any_instance.stub(:winner_on_board).and_return("x")

      GameRecorder.should_receive(:write_winner).once.with(id,"x")

      post '/move'
    end
  end
end
