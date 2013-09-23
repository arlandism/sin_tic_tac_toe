require 'rack/test'

require_relative '../../app'

describe 'TTTDuet' do
  include Rack::Test::Methods

  before(:each) do 
    History.stub(:write_move)
    History.stub(:write_winner)
  end

  def app
    TTTDuet.new
  end

  def verify_cookie_value(key,val)
    cookie_key = key.to_s
    rack_mock_session.cookie_jar[cookie_key].should == val
  end

  def should_arrive_at_expected_path(expected_path)
    default_url = "http://example.org"
    last_request.url.should == default_url + expected_path
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
      should_arrive_at_expected_path("/")
    end

    it "sets the information it gets from players and service" do
      @game_info.stub(:winner_on_board).and_return(nil)
      NextPlayer.stub(:move).and_return(3)

      post '/move', {:player_move => 5}
      verify_cookie_value(5,"x")
      verify_cookie_value(3,"o")
      verify_cookie_value("winner","")
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
      verify_cookie_value(3,"x")
      verify_cookie_value(6,"o")
      verify_cookie_value(4,"x")
    end

    it "generates an id if it doesn't have one already" do
      @game_info.stub(:winner_on_board)
      NextPlayer.stub(:move)
      post '/move', {:player_move => 3}
      rack_mock_session.cookie_jar["id"].should_not == nil
    end
  end
end
