require 'sinatra'
require 'haml'

require_relative 'lib/presenters/winner_presenter'
require_relative 'lib/presenters/button_presenter'
require_relative 'lib/ai'

class TTTDuet < Sinatra::Base

  get '/' do
    haml :index 
  end

  get '/clear' do
    request.cookies.each_key { |key| response.delete_cookie(key)}
    redirect '/'
  end

  get '/config' do
    haml :config
  end

  post '/config' do
    first_player = params[:first_player]
    difficulty = params[:difficulty]
    response.set_cookie("depth", difficulty)
    response.set_cookie("first_player",first_player)
    redirect '/'
  end

  post '/move' do
    move = params[:player_move]
    @request.cookies[move] = "x"
    latest_state = {"board" => @request.cookies}
    depth = @request.cookies["depth"]
    if depth
      latest_state["depth"] = depth.to_i
    end
    service_response = AI.new.next_move(latest_state)
    response.set_cookie(move,"x")
    response.set_cookie(service_response["move"], "o")
    service_response["winner"] ? response.set_cookie("winner", service_response["winner"]): nil
    redirect '/'
  end

end

if __FILE__ == $0 
  TTTDuet.run!
end
