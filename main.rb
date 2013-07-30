require 'sinatra'
require 'haml'

  get '/' do
    @board = request.cookies
    haml :index 
  end

  post '/move' do
    move = params[:player_move]
    response.set_cookie(move, "x")
    redirect '/'
  end
