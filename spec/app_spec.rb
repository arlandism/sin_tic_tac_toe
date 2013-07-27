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

  describe "GET '/game/move'" do

    it 'renders game page with valid move' do
      get '/game/3'
      last_response.status.should be 200
    end

    it "renders separate page for invalid move" do
      get '/game/7'
        valid_body = last_response.body

      get '/game/36'
        last_response.body.should_not == valid_body
    end
  end
end
