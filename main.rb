require 'sinatra'
require 'haml'
require_relative 'lib/client'
require 'json'

get '/' do
 haml :index 
end

get '/game/:move' do
  move = params[:move].to_i
  if valid_move?((1..9),move)
  #socket = ClientSocket.new 6000
  #socket.connect!
  #socket.send JSON.dump({9 => "x"})
  #socket.close!
  haml :game
  else
    haml :invalid_move
  end
end

def valid_move?(coll,move)
  coll.include? move 
end
