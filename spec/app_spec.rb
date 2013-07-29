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
     last_response.body.should_not == ""
     end
  end

  describe "POST '/move'" do

    def post_request_with_valid_move(move=6)
      post '/move', {:player_move => move.to_s}
    end

    def check_cookie_state(key,val)
      rack_mock_session.cookie_jar[key.to_s].should == val
    end

    it "opens a socket and sends the move in JSON" do
      socket = TCPServer.open(6000)
      post_request_with_valid_move
      conn = socket.accept()
      data = conn.gets
      data.gsub("\n","").should == JSON.dump({"6" => "x"})
    end

    it "redirects to index" do
      post_request_with_valid_move
      follow_redirect!
      expected_path = "/"
      last_request.url.should == "http://example.org" + expected_path
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
  end
end
