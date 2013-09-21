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

      GameRepository.stub(:game_by_id).and_return({"moves" => [], "winner" => nil})
      get '/games/22'

      rack_mock_session.cookie_jar["id"].should == "22"
    end

    it "polls History for the list of games" do
      History.should_receive(:retrieve_or_create).
        with(TTTDuet.settings.history_path)

      get '/games/22' 
    end

    it "calls the presenter with the game it got back" do
      id = "22"
      games = {"games" => {}}

      History.should_receive(:retrieve_or_create).
        with(TTTDuet.settings.history_path).
        and_return(games)

      get '/games/22'
    end
  end

end
