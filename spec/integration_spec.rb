ENV["RACK_ENV"] = "test"

require 'rack/test'
require 'db_history'
require_relative '../app'

describe "integration" do

  include Rack::Test::Methods

  def app
    TTTDuet.new
  end

  before(:each) do
    ClientSocket.any_instance.stub(:connect!)
    File.stub(:write)
  end

  context "with service" do

    let(:game_info) { double(:game_info) }

    before(:each) do
      FileHistory.stub(:write_move)
      FileHistory.stub(:write_winner)
      GameInformation.stub(:new).and_return(game_info)
    end

    it "hands the game state and configurations to AI" do
      rack_mock_session.cookie_jar["depth"] = 10
      rack_mock_session.cookie_jar["winner"] = nil
      rack_mock_session.cookie_jar["id"] = 75
      move = 6
      token = "x"
      id_in_response = "75\n"
      current_board_state = {move.to_s => token,
                             "depth" => "10",
                             "winner" => "",
                             "id" => id_in_response}

      NextPlayer.should_receive(:move).once.with(current_board_state)
      post '/move', {:player_move => move}
    end
  end

  context "with FileHistory" do

    let(:id) { 24 }

    before(:each) do
      rack_mock_session.cookie_jar["id"] = id
    end

    it "delegates moves to FileHistory" do
      NextPlayer.stub(:move).and_return(4)
      GameInformation.any_instance.stub(:winner_on_board)

      FileHistory.should_receive(:write_move).once.with(id,34,"x", app.settings.history_path)
      FileHistory.should_receive(:write_move).once.with(id,4,"o", app.settings.history_path)

      post '/move', {:player_move => 34}
    end

    it "delegates winners to FileHistory" do
      NextPlayer.stub(:move)
      GameInformation.any_instance.stub(:winner_on_board).and_return("x")
      FileHistory.should_receive(:write_winner).once.with(id,"x", app.settings.history_path)

      post '/move'
    end
    
  end

  context "with Random" do

    it "calls FileHistory for next i.d" do
      NextPlayer.stub(:move)
      GameInformation.any_instance.stub(:winner_on_board)
      FileHistory.should_receive(:next_id).
        and_return(50)

      post '/move'
      rack_mock_session.cookie_jar["id"].should == "50"
    end
  end

  context "with database" do

    xit "writes moves to the database" do
      id = 5
      rack_mock_session.cookie_jar["id"] = id
      NextPlayer.stub(:move)
      GameInformation.any_instance.stub(:winner_on_board)
      TestDBMethods.login_to_test_db

      post '/move', {:player_move => 3}

      move = DBHistory.retrieve_or_create(path)["games"][id]["moves"][0]
      move["position"].should == 3 
      move["token"].should == "x" 
    end
  end

end
