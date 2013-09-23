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

  def should_arrive_at_expected_path(expected_path)
    default_url = "http://example.org"
    last_request.url.should == default_url + expected_path
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
end
