require './main'
require 'rack/test'

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
    it "redirects to index" do
      post_request_with_valid_move
      follow_redirect!
      default_url = "http://example.org"
      expected_path = "/"
      last_request.url.should == default_url + expected_path
    end

    it "stores a move cookie " do
      post_request_with_valid_move
      check_cookie_state(6,"x")
    end

    it "has cookies that are persistent across requests" do
      post_request_with_valid_move
      get '/'
      check_cookie_state(6,"x")
    end

    def post_request_with_valid_move(move=6)
      post '/move', {:player_move => move.to_s}
    end

    def check_cookie_state(key,val)
      rack_mock_session.cookie_jar[key.to_s].should == val
    end

    after(:each) do
      rack_mock_session.clear_cookies
    end
  end
end
