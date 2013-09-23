require_relative 'route_spec_helper'

describe TTTDuet do
  include Rack::Test::Methods

  before(:each) do
    File.stub(:write)
  end

  describe "POST '/move'" do

    before(:each) do 
      ClientSocket.any_instance.stub(:connect!) 
      @game_info = double(:fake_info)
      GameInformation.stub(:new).and_return(@game_info)
    end

    it "eventually redirects to index" do
      @game_info.stub(:winner_on_board)
      NextPlayer.stub(:move)

      post '/move'
     
      follow_redirect! 
      SpecUtils::should_arrive_at_expected_path(last_request, "/")
    end

    it "sets the information it gets from players and service" do
      @game_info.stub(:winner_on_board).and_return(nil)
      NextPlayer.stub(:move).and_return(3)

      post '/move', {:player_move => 5}
      SpecUtils::verify_cookie_value(rack_mock_session.cookie_jar, 5,"x")
      SpecUtils::verify_cookie_value(rack_mock_session.cookie_jar, 3,"o")
      SpecUtils::verify_cookie_value(rack_mock_session.cookie_jar, "winner","")
    end
    
    it "shouldn't call NextPlayer if there's a winner" do
      @game_info.stub(:winner_on_board).and_return("x")
      NextPlayer.should_not_receive(:move)
      post '/move',{:player_move => 3}
    end
    
    it "rotates tokens" do
      rack_mock_session.cookie_jar["first_player"] = "computer"
      rack_mock_session.cookie_jar["second_player"] = "human"
      @game_info.stub(:winner_on_board)
      NextPlayer.stub(:move).and_return(3,4)
      get '/'

      post '/move', {:player_move => 6}
      SpecUtils::verify_cookie_value(rack_mock_session.cookie_jar, 3,"x")
      SpecUtils::verify_cookie_value(rack_mock_session.cookie_jar, 6,"o")
      SpecUtils::verify_cookie_value(rack_mock_session.cookie_jar, 4,"x")
    end

    it "generates an id if it doesn't have one already" do
      @game_info.stub(:winner_on_board)
      NextPlayer.stub(:move)
      post '/move', {:player_move => 3}
      rack_mock_session.cookie_jar["id"].should_not == nil
    end
  end
end
