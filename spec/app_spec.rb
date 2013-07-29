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

  describe "POST '/move/'" do

    it "opens a socket and sends the move in JSON" do
      socket = TCPServer.open(6000)
      post '/move', {:player_move => "6"}
      conn = socket.accept()
      data = conn.gets
      data.gsub("\n","").should == JSON.dump({"6" => "x"})
    end

    it "redirects once its done" do
      post '/move', {:player_move => "5"}
      last_response.status.should be 302
      follow_redirect!
      last_response.status.should be 200
      expected_path = "/"
      last_request.url.should == "http://example.org" + expected_path
    end

    it "stores a move cookie " do
      post '/move', {:player_move => "9"}
      rack_mock_session.cookie_jar["9"].should == "x"
    end

    it "has cookies persistent across requests" do
      post '/move', {:player_move => "6"}
      get '/'
      rack_mock_session.cookie_jar["6"].should == "x"
    end
  end
end
