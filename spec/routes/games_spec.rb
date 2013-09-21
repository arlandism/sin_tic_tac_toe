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

    it "polls History for the queried game" do

      game = {
        "moves" => [{"position" => 2, "token" => "x"}],
        "winner" => "me!"
        }
      game_id = "22"

      History.should_receive(:retrieve_or_create).
        with(TTTDuet.settings.history_path).
        and_return({"games" => {game_id => game}})

      get '/games/22' 

      rack_mock_session.cookie_jar["id"].should == "22"
      rack_mock_session.cookie_jar["moves"].should == JSON.dump(game["moves"])
      rack_mock_session.cookie_jar["winner"].should == "me!"
    end
  end

end
