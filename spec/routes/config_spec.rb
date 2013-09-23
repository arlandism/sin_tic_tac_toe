require_relative 'route_spec_helper'
require_relative 'spec_utils'

describe TTTDuet do
  include Rack::Test::Methods

  let (:utils) {SpecUtils}
  
  describe "GET '/config'" do
    it "renders" do
      get '/config'
      last_response.status.should == 200
      last_response.body.should_not == ""
    end
  end

  describe "POST '/config'" do

    it "sets the configurations" do

      configurations = {
        :depth => 10, 
        :first_player => "computer", 
        :second_player => "human"
      } 

      post '/config', configurations 

      utils.verify_cookie_value(rack_mock_session.cookie_jar, "depth", "10")

      utils.verify_cookie_value(rack_mock_session.cookie_jar, "first_player", "computer")

      utils.verify_cookie_value(rack_mock_session.cookie_jar, "second_player", "human")

    end

    it "redirects to the index once its done" do
      post '/config'
      follow_redirect!
      utils.should_arrive_at_expected_path(last_request, "/")
    end
  end
end
