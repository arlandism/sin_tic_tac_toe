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
    request.cookies.each_key { |key| response.delete_cookie(key) }
    redirect '/'
  end

  get '/config' do
    haml :config
  end

  post '/config' do
    difficulty = params[:difficulty]
    first_player = params[:first_player]
    response.set_cookie("depth", difficulty)
    if first_player == "computer"
      ai_move = AI.new.next_move("board" => {})
      response.set_cookie(ai_move["move"],"o")
    end
    redirect '/'
  end

  post '/move' do
    latest_move = params[:player_move]
    game_state = prepare_game_state_for_service(latest_move) 
    service_response = AI.new.next_move(game_state)
    response.set_cookie(latest_move,"x")
    response.set_cookie(service_response["move"], "o")
    service_response["winner"] ? response.set_cookie("winner", service_response["winner"]): nil
    redirect '/'
  end

  def prepare_game_state_for_service(latest_move)
    game_state = {"board" => request.cookies.select{ |key,_| key=~/^[0-9]+$/ }}
    game_state["board"][latest_move] = "x"
    game_state["depth"] = request.cookies.fetch("depth", nil)
    return game_state
  end

end


if __FILE__ == $0 
  TTTDuet.run!
end
