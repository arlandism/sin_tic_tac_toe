require 'rack/test'
require_relative '../main'

describe 'TTTDuet' do
  include Rack::Test::Methods

  def app
    TTTDuet.new
  end

  def verify_cookie_value(key,val)
    cookie_key = key.to_s
    rack_mock_session.cookie_jar[cookie_key].should == val
  end

  describe "GET '/'" do

    it 'renders index' do
      get '/'
      last_response.status.should be 200
    end

    it "calls service and stores move cookie if first_player is computer" do
      rack_mock_session.cookie_jar["first_player"] = "computer"
      ai = double(:ai)
      AI.stub(:new).and_return(ai)
      ai.should_receive(:next_move).and_return({"ai_move" => "fake_cookie"})
      get '/'
      verify_cookie_value("fake_cookie","o")
      rack_mock_session.cookie_jar["fake_cookie"].should == "o"
    end

    it "doesn't call the service if moves have been made" do
      ai = double(:ai)
      AI.stub(:new).and_return(ai)
      ai.stub(:next_move).and_return("ai_move" => 2)
      ai.should_receive(:next_move).once

      post '/config', {:first_player => "computer"}
      post '/move', {:player_move => 4}
      get '/'
    end

    describe "root" do
      it "does not place a move if cpumove says not to" do
        CpuMove.should_receive(:should_place).and_return(false)

        AI.any_instance.should_not_receive(:next_move)

        get '/'
      end

      it "places a move cpu says to" do
        CpuMove.should_receive(:should_place).and_return(true)

        AI.any_instance.should_not_receive(:next_move)

        get '/'
      end

      it "asks right question of cpumove" do
        game_description = {"the" => "stuff"}

        rack_mock_session.cookie_jar["the"] = "stuff"

        CpuMove.should_receive(:should_place).with(game_description)

        get '/'
      end
    end
  end

  describe "POST '/move'" do

    before(:each) { ClientSocket.any_instance.stub(:connect!) }
    let(:default_move) { {"ai_move" => 3} }
    let(:default_url) {"http://example.org"}

    it "stores player cookies and redirects" do
      AI.any_instance.stub(:next_move).and_return(default_move)
      post '/move', {:player_move => 5}
      verify_cookie_value(5,"x")
      follow_redirect!
      expected_path = "/"
      last_request.url.should == default_url + expected_path
    end
    
    it "it stores the game information from AI" do
      game_information = {"ai_move" => 3, "winner" => "x"}
      AI.any_instance.stub(:next_move).and_return(game_information)
      post '/move', {:player_move => 2}
      verify_cookie_value("winner","x")
      verify_cookie_value("3","o")
    end

    it "hands the game state and configurations to AI" do
      post '/config', {:depth => 10}
      current_board_state = {"board" => {"6" => "x"},
                             "depth" => "10"}
      AI.any_instance.should_receive(:next_move).with(current_board_state)
      post '/move', {:player_move => 6}
    end
  end

  describe "GET '/clear' " do

    it "redirects to index" do
      get '/clear'
      follow_redirect!
      last_response.status.should == 200
      default_url = "http://example.org"
      expected_path = "/"
      last_request.url.should == default_url + expected_path
    end

      it "clears state cookies but not config" do
        cookies_to_be_deleted = ["1","2","3","winner"]
        persistent_cookies = ["first_player", "depth"]
        all_cookies =  cookies_to_be_deleted + persistent_cookies
        all_cookies.each {|val| rack_mock_session.cookie_jar[val] = "x"}
        get '/clear'
        cookies_to_be_deleted.each {|val| rack_mock_session.cookie_jar[val].should == "" }
        persistent_cookies.each {|val| rack_mock_session.cookie_jar[val].should_not == "" }
      end
    end

  describe "GET '/config'" do

    it "renders" do
      get '/config'
      last_response.status.should == 200
      last_response.body.should_not == ""
    end
  end

  describe "POST '/config'" do

    it "sets the configurations" do
      post '/config', {:depth => 10, :first_player => "computer"}
      rack_mock_session.cookie_jar["first_player"].should == "computer"
      rack_mock_session.cookie_jar["depth"].should == "10" 
    end

    it "redirects to the index once its done" do
      post '/config', {:depth => 20}
      follow_redirect!
      default_url = "http://example.org"
      expected_path = "/"
      last_request.url.should == default_url + expected_path
    end
  end 
end
