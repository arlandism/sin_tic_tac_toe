require 'sinatra'
require 'haml'
require_relative 'lib/client'
require_relative 'lib/data_manager'

get '/' do
  @board = request.cookies
  haml :index 
end

post '/move' do
  move = params[:player_move].to_i
  send_the_move!(move)
  response.set_cookie(move, "x")
  redirect '/'
end

def send_the_move!(move)
  socket = ClientSocket.new(6000)
  socket.connect!
  manager = DataManager.new(socket)
  manager.send({move => "x"})
end
