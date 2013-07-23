require 'main'
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

  describe "POST '/game'" do
    it 'renders game page' do
      post '/game'
        last_response.status.should be 200
    end
  end
end
