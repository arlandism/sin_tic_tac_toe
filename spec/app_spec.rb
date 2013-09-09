require 'rack/test'
require_relative '../app'

describe 'TTTDuet' do
  include Rack::Test::Methods

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

  describe "GET '/'" do

    before(:each) do
      @ai = double(:ai)
      AI.stub(:new).and_return(@ai)
    end

    it 'renders index' do
      get '/'
      last_response.status.should be 200
    end

    it "calls service and stores move cookie if first_player is computer" do
      CpuMove.stub(:should_place).and_return(true)
      NextPlayer.should_receive(:move).and_return("fake_move")

      get '/'

      verify_cookie_value("fake_move","x")
    end

     it "does not place a move if cpumove says not to" do
       CpuMove.should_receive(:should_place).and_return(false)

       @ai.should_not_receive(:next_move)

       get '/'
     end

     it "places a move if cpu says to" do
       CpuMove.should_receive(:should_place).and_return(true)

       @ai.should_receive(:next_move)

       get '/'
     end

     it "asks right question of cpumove" do
       game_description = {"the" => "stuff"}

       rack_mock_session.cookie_jar["the"] = "stuff"

       CpuMove.should_receive(:should_place).with(game_description)

       get '/'
      end
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
    
    it "rotates tokens when computer moves first" do
      rack_mock_session.cookie_jar["first_player"] = "computer"
      rack_mock_session.cookie_jar["second_player"] = "human"
      @game_info.stub(:winner_on_board)
      NextPlayer.stub(:move).and_return(3,4)
      get '/'

      post '/move', {:player_move => 6}
      verify_cookie_value(3,"x")
      verify_cookie_value(4,"x")
      verify_cookie_value(6,"o")
    end

  end

  describe "GET '/clear' " do

    it "redirects to index" do
      get '/clear'
      follow_redirect!
      should_arrive_at_expected_path("/")
    end

    it "clears state cookies but not config" do
      cookies_to_be_deleted = ["1","2","3","winner"]
      persistent_cookies = ["first_player", "second_player", "depth"]
      set_all_the_cookies(persistent_cookies,cookies_to_be_deleted)
      get '/clear'

      assert_config_cookies_live(persistent_cookies)
      assert_non_config_cookies_dead(cookies_to_be_deleted)
    end

    def assert_config_cookies_live(config_cookies) 
      config_cookies.each {|val| rack_mock_session.cookie_jar[val].should_not == "" }
    end

    def assert_non_config_cookies_dead(cookies_that_should_be_dead)
      cookies_that_should_be_dead.each {|val| rack_mock_session.cookie_jar[val].should == "" }
    end

    def set_all_the_cookies(cookie_group_one, cookie_group_two)
      all_cookies =  cookie_group_one + cookie_group_two
      all_cookies.each {|val| rack_mock_session.cookie_jar[val] = "x"}
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
      configurations = {:depth => 10, :first_player => "computer", :second_player => "human"} 
      post '/config', configurations 
      rack_mock_session.cookie_jar["first_player"].should == "computer"
      rack_mock_session.cookie_jar["second_player"].should == "human"
      rack_mock_session.cookie_jar["depth"].should == "10" 
    end

    it "redirects to the index once its done" do
      post '/config'
      follow_redirect!
      should_arrive_at_expected_path("/")
    end
  end 

  describe "integration" do

    before(:each) do
      ClientSocket.any_instance.stub(:connect!) 
      @game_info = double(:game_info)
      GameInformation.stub(:new).and_return(@game_info)
    end

    it "hands the game state and configurations to AI" do
      post '/config', {:depth => 10}
      current_board_state = {"board" => {"6" => "x"},
                             "depth" => "10"}
      @game_info.stub(:winner_on_board)
      @game_info.stub(:service_response).and_return("ai_move" => 3)
      post '/move', {:player_move => 6}
    end
  end
end
