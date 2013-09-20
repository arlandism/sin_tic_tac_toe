require 'rack/test'

require_relative '../../app'

describe TTTDuet do
  include Rack::Test::Methods

  def app
    TTTDuet.new
  end

  describe ".get '/games/[0-9]+'" do
    
    it "takes me to the page of the game" do
      get '/games/22' 
      last_response.status.should == 200 
    end 
  end

end
