require 'sinatra'
require 'haml'

require_relative 'lib/presenters/winner_presenter'
require_relative 'lib/presenters/button_presenter'
require_relative 'lib/ai'

class TTTDuet < Sinatra::Base

  set :difficulty, 20
  set :first_player, "human"
  set :game_state, {}

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
    self.settings.difficulty = difficulty.to_i
    if first_player == "computer"
      ai_move = AI.new.next_move("board" => {})
      response.set_cookie(ai_move["move"],"o")
    end
    redirect '/'
  end

  post '/move' do
    latest_move = params[:player_move]
    service_response = return_service_response(latest_move)
    response.set_cookie(latest_move,"x")
    response.set_cookie(service_response["move"], "o")
    service_response["winner"] ? response.set_cookie("winner", service_response["winner"]): nil
    redirect '/'
  end

  def return_service_response(latest_move)
    game_state = {"board" => request.cookies}
    game_state["board"][latest_move] = "x"
    game_state["depth"] = self.settings.difficulty
    return AI.new.next_move(game_state)
  end

end


if __FILE__ == $0 
  TTTDuet.run!
end
