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
  if valid_move? move 
    send_the_move!(move)
    response.set_cookie(move, "x")
    redirect '/'
  else
    haml :invalid_move
  end
end

def valid_move?(move)
  (1..9).include? move
end

def send_the_move!(move)
  socket = ClientSocket.new(6000)
  socket.connect!
  manager = DataManager.new(socket)
  manager.send({move => "x"})
end
