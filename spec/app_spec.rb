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
