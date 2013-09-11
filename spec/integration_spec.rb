require 'rack/test'
require_relative '../app'

describe "integration" do

  include Rack::Test::Methods

  def app
    TTTDuet.new
  end

  before(:each) do
    ClientSocket.any_instance.stub(:connect!) 
    @game_info = double(:game_info)
    GameInformation.stub(:new).and_return(@game_info)
    GameRecorder.stub(:write_move)
    GameRecorder.stub(:write_winner)
  end

  it "hands the game state and configurations to AI" do
    post '/config', {:depth => 10}
    current_board_state = {"board" => {"6" => "x"},
                           "depth" => "10"}
    @game_info.stub(:winner_on_board)
    @game_info.stub(:service_response).and_return("ai_move" => 3)
    post '/move', {:player_move => 6}
  end

  it "delegates moves to GameRecorder" do
    rack_mock_session.cookie_jar["id"] = 24
    NextPlayer.stub(:move).and_return(4)
    @game_info.stub(:winner_on_board).and_return("x")
    GameRecorder.should_receive(:write_move).once.with(24,{4 => "o"})
    GameRecorder.should_receive(:write_move).once.with(24,{34 => "x"})
    post '/move', {:player_move => 34}
  end

  it "delegates winners to GameRecorder" do
    rack_mock_session.cookie_jar["id"] = 24
    NextPlayer.stub(:move)
    @game_info.stub(:winner_on_board).and_return("x")
    GameRecorder.should_receive(:write_winner).once.with(24,"x")
    post '/move'
  end
end
