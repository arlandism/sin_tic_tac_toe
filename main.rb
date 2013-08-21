require 'sinatra'
require 'haml'

require_relative 'lib/winner_presenter'
require_relative 'lib/button_presenter'
require_relative 'lib/state_manager'

class TTTDuet < Sinatra::Base

  get '/' do
    @board = request.cookies
    haml :index 
  end

  get '/clear' do
    request.cookies.keys.each do |key|
      response.delete_cookie(key)
    end
    redirect '/'
  end

  get '/config' do
    haml :config
  end

  post '/config' do
    response.set_cookie("depth",params[:difficulty])
    redirect '/'
  end

  post '/move' do
    move = params[:player_move]
    StateManager.new(request, response, move).set_cookies
    redirect '/'
  end

end

if __FILE__ == $0
  TTTDuet.run!
end
