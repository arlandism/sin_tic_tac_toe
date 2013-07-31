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
  end

  describe "POST '/move'" do

    before(:each) do
      ClientSocket.any_instance.stub(:connect!)
      AI.any_instance.stub(:next_move)
    end

    it "redirects to index" do
      execute_post_request_with_move 5
      follow_redirect!
      default_url = "http://example.org"
      expected_path = "/"
      last_request.url.should == default_url + expected_path
    end


    it "stores player move cookie " do
      execute_post_request_with_move 6
      verify_cookie_value(6,"x")
    end

    it "stores AI move cookie" do
      AI.any_instance.stub(:next_move).and_return(12)
      execute_post_request_with_move 6
      verify_cookie_value(12,"o")
    end

    it "stores AI move again" do
      AI.any_instance.stub(:next_move).and_return(82)
      execute_post_request_with_move 6
      verify_cookie_value(82,"o")
    end

    it "has cookies that are persistent across requests" do
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

    context "cookies containing both tokens"
    it "has cookies that are persistent across multiple post requests" do
      ai = mock(:AI)
      AI.stub(:new).and_return(ai)
      ai.stub(:next_move).and_return(6)
      execute_post_request_with_move 8
      execute_post_request_with_move 5
      verify_cookie_value(8,"x")
      verify_cookie_value(5,"x")
      verify_cookie_value(6,"o")
    end

    context "after multiple requests"
    it "gives AI.next current cookies" do
      ai = mock(:AI)
      AI.stub(:new).and_return(ai)
      ai.stub(:next_move).and_return(5)
      execute_post_request_with_move 6
      verify_cookie_value(6,"x")
      verify_cookie_value(5,"o")
      current_board_state = {5 => "o", 6 => "x", 7 => "x"}
      ai.should_receive(:next_move).with(current_board_state)
      execute_post_request_with_move 7
    end

    def execute_post_request_with_move(move)
      post '/move', {:player_move => move.to_s}
    end

    def verify_cookie_value(key,val)
      cookie_key = key.to_s
      rack_mock_session.cookie_jar[cookie_key].should == val
    end

    after(:each) do
      rack_mock_session.clear_cookies
    end
  end
end
