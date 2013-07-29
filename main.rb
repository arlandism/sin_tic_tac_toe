require 'sinatra'
require 'haml'
require_relative 'lib/client'
require_relative 'lib/data_manager'

  get '/' do
    @board = request.cookies
    haml :index 
  end

  post '/move' do
    move = params[:player_move]
    response.set_cookie(move, "x")
    redirect '/'
  end
