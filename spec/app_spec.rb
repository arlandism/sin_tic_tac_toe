require 'rack/test'
require './main'

describe 'main' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe "GET '/'" do
    it 'renders index' do
     get '/'
     last_response.status.should be 200
     end

    context "x is the winner" do
      it "shows a win message if there's winner" do
        set_cookie("winner=x")
        get '/'
        last_response.status.should be 200
        last_response.body.should include "x wins"
      end
    end

    context "o is the winner" do
      it "shows a win message if there's winner" do
        set_cookie("winner=o")
        get '/'
        last_response.status.should be 200
        last_response.body.should include "o wins"
      end
    end

    it "shouldn't show a win message if there's no winner" do
      get '/'
      last_response.body.should_not include "x wins"
    end
  end

  describe "POST '/move'" do

    default_move = {"move" => 3}
    
    it "redirects to index" do
      AI.any_instance.stub(:new)
      AI.any_instance.stub(:next_move).and_return(default_move)
      execute_post_request_with_move 5
      follow_redirect!
      default_url = "http://example.org"
      expected_path = "/"
      last_request.url.should == default_url + expected_path
    end

    it "stores player move cookie " do
      AI.any_instance.stub(:new)
      AI.any_instance.stub(:next_move).and_return(default_move)
      execute_post_request_with_move 6
      verify_cookie_value(6,"x")
    end

    it "stores AI move cookie" do
      AI.any_instance.stub(:next_move).and_return(default_move)
      execute_post_request_with_move 6
      verify_cookie_value(3,"o")
    end

    it "stores AI move again" do
      AI.any_instance.stub(:next_move).and_return({"move" => 82})
      execute_post_request_with_move 6
      verify_cookie_value(82,"o")
    end

    it "has cookies that are persistent across requests" do
      AI.any_instance.stub(:next_move).and_return(default_move)
      execute_post_request_with_move 6
      get '/'
      verify_cookie_value(6,"x")
    end

    it "gives AI.next_move current cookies" do
      ai = mock(:AI)
      AI.stub(:new).and_return(ai)
      ai.should_receive(:next_move).with({9 => "x"})
      execute_post_request_with_move 9
    end

    context "cookies containing both tokens" do
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
    end

    context "after multiple requests" do
      it "gives AI.next current cookies" do
        ai = mock(:AI)
        AI.stub(:new).and_return(ai)
        ai.stub(:next_move).and_return({"move" => 5})
        execute_post_request_with_move 9
        current_board_state = {5 => "o", 9 => "x", 8 => "x"}
        ai.should_receive(:next_move).with(current_board_state)
        execute_post_request_with_move 8
      end
    end

    it "gets the winner from AI" do
      game_stuff = {"move" => 3, "winner" => "x"}
      ai = mock(:AI)
      AI.stub(:new).and_return(ai)
      ai.stub(:next_move).and_return(game_stuff)
      execute_post_request_with_move 2
      rack_mock_session.cookie_jar["winner"].should == "x"
    end

    def execute_post_request_with_move(move)
      post '/move', {:player_move => move.to_s}
    end

    def verify_cookie_value(key,val)
      cookie_key = key.to_s
      rack_mock_session.cookie_jar[cookie_key].should == val
    end

    before(:each) do
      ClientSocket.any_instance.stub(:connect!)
      AI.any_instance.stub(:next_move)
    end

    after(:each) do
      rack_mock_session.clear_cookies
    end
  end

  describe "#winner" do
    context "o is the winner"
    it "pulls winner out of a hash" do
      winner({"winner" => "o"}).should == "o"
    end

    context "x is the winner"
    it "pulls winner out of a hash" do
      winner({"winner" => "x"}).should == "x"
    end

    context "winner is nil"
    it "pulls winner out of hash" do
      winner({"winner" => nil}).should == nil
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

    it "works with 1 cookie set" do
      rack_mock_session.cookie_jar["3"] = "x"
      get '/clear'
      follow_redirect!
      rack_mock_session.cookie_jar["3"].should == ""
    end
    
    context "all board keys" do
      it "works with multiple cookies set" do
        cookie_list = ["1","2","3","4"]
        cookie_list.each do |n|
          rack_mock_session.cookie_jar[n] = "x"
        end
        get '/clear'
        follow_redirect!
        cookie_list.each do |n|
          rack_mock_session.cookie_jar[n].should == ""
        end
      end
    end
    
    context "mix of board information" do
      it "works with multiple cookies set" do
        cookie_list = ["1","2","3","winner"]
        cookie_list.each do |n|
          rack_mock_session.cookie_jar[n] = "x"
        end
        get '/clear'
        follow_redirect!
        cookie_list.each do |n|
          rack_mock_session.cookie_jar[n].should == ""
        end
      end
    end

  end

  #describe "integration" 
  #  it "gets a move from AI and stores it as a cookie" do
  #    post '/move', {:player_move => 3}   
  #    rack_mock_session.cookie_jar["3"].should == "x"
  #  end
end
