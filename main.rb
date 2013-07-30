require 'sinatra'
require 'haml'
require_relative 'lib/ai.rb'

  get '/' do
    @board = request.cookies
    haml :index 
  end

  post '/move' do
    move = params[:player_move]
    response.set_cookie(move, "x")
    response.set_cookie(AI.new.next_move,"o")
    redirect '/'
  end
