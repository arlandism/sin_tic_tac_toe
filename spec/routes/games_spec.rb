require 'rack/test'
require 'json'

require_relative '../../app'

describe TTTDuet do
  include Rack::Test::Methods

  def app
    TTTDuet.new
  end

  describe ".get '/games/[0-9]+'" do
    
    it "takes me to the page of the game" do
      get '/games/22' 
      last_request.url.should == "http://example.org/games/22" 
    end 

    it "sets the id of the game I requested" do
      id = "22"

      FileHistory.stub(:game_by_id).and_return({"moves" => [], "winner" => nil})
      get '/games/22'

      rack_mock_session.cookie_jar["id"].should == "22"
    end

    it "polls History for the list of games" do
      FileHistory.should_receive(:game_by_id).
        with(TTTDuet.settings.history_path, "22")

      get '/games/22' 
    end
  end

end
