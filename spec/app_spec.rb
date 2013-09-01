require 'rack/test'
require_relative '../main'

describe 'TTTDuet' do

  include Rack::Test::Methods

  def app
    TTTDuet.new
  end

  describe "GET '/'" do

    it 'renders index' do
      get '/'
      last_response.status.should be 200
    end

  end

  describe "POST '/move'" do

    default_move = {"move" => 3}
    default_url = "http://example.org"

    it "stores player cookies and redirects" do
      AI.any_instance.stub(:new)
      AI.any_instance.stub(:next_move).and_return(default_move)
      execute_post_request_with_move 5
      verify_cookie_value(5,"x")
      follow_redirect!
      expected_path = "/"
      last_request.url.should == default_url + expected_path
    end
    
    it "gets the winner from AI" do
      game_stuff = {"move" => 3, "winner" => "x"}
      ai = mock(:AI)
      AI.stub(:new).and_return(ai)
      ai.stub(:next_move).and_return(game_stuff)
      execute_post_request_with_move 2
      rack_mock_session.cookie_jar["winner"].should == "x"
    end

      it "has cookies that are persistent across multiple post requests" do
        ai = mock(:AI)
        AI.stub(:new).and_return(ai)
        ai.stub(:next_move).and_return({"move" => 6})
        execute_post_request_with_move 8
        execute_post_request_with_move 5
        verify_cookie_value(8,"x")
        verify_cookie_value(5,"x")
        verify_cookie_value(6,"o")
      end

    it "hands the game state and configurations to AI" do
      post '/config', {:difficulty => 10}
      current_board_state = {"board" => {"6" => "x"},
                             "depth" => "10"}
      AI.any_instance.should_receive(:next_move).with(current_board_state)
      execute_post_request_with_move 6
    end

      it "hands off state to AI with AI moves already made" do
        ai = mock(:AI)
        AI.stub(:new).and_return(ai)
        ai.stub(:next_move).and_return({"move" => 5})
        execute_post_request_with_move 9
        current_board_state = {"board" => {"5" => "o", "9" => "x", "8" => "x"},
                               "depth" => nil}
        ai.should_receive(:next_move).with(current_board_state)
        execute_post_request_with_move 8
      end

    before(:each) do
      ClientSocket.any_instance.stub(:connect!)
      AI.any_instance.stub(:next_move)
    end

    after(:each) do
      rack_mock_session.clear_cookies
    end

   def execute_post_request_with_move(move)
      post '/move', {:player_move => move.to_s}
    end

    def verify_cookie_value(key,val)
      cookie_key = key.to_s
      rack_mock_session.cookie_jar[cookie_key].should == val
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

      it "clears all the move cookies" do
        cookie_list = ["1","2","3","4"]
        cookie_list.each {|val| rack_mock_session.cookie_jar[val] = "x"}
        get '/clear'
        cookie_list.each {|val| rack_mock_session.cookie_jar[val].should == ""}
      end
    
      it "clears move cookies and descriptive cookies" do
        cookie_list = ["1","2","3","winner"]
        cookie_list.each {|val| rack_mock_session.cookie_jar[val] = "x"}
        get '/clear'
        cookie_list.each {|val| rack_mock_session.cookie_jar[val].should == ""}
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

    it "sets the difficulty cookie" do
      post '/config', {:difficulty => 20}
      rack_mock_session.cookie_jar["depth"].should == "20"
    end

    it "calls the service if first_player is set to computer and sets its move in the cookie" do
      ai = double(:ai)
      AI.stub(:new).and_return(ai)
      ai.should_receive(:next_move).and_return({"move" => "fake cookie"})
      post '/config', {:first_player => "computer"}
      rack_mock_session.cookie_jar["fake cookie"].should ==  "o"
    end

    it "redirects to the index once its done" do
      post '/config', {:difficulty => 20}
      follow_redirect!
      default_url = "http://example.org"
      expected_path = "/"
      last_request.url.should == default_url + expected_path
    end

  end 
end
