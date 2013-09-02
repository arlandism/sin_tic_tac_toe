require 'sinatra'
require 'sinatra/cookies'
require 'haml'

require_relative 'lib/presenters/winner_presenter'
require_relative 'lib/presenters/button_presenter'
require_relative 'lib/ai'

class TTTDuet < Sinatra::Base
  helpers Sinatra::Cookies

  get '/' do
    if cookies[:first_player] == "computer"
      ai_move = AI.new.next_move("board" => {})
      response.set_cookie(ai_move["move"], "o")
    end
    haml :index 
  end

  get '/clear' do
    cookies.each_key do |cookie| 
      response.delete_cookie(cookie) unless configuration_setting?(cookie)
    end
    redirect '/'
  end

  get '/config' do
    haml :config
  end

  post '/config' do
    difficulty = params[:difficulty]
    first_player = params[:first_player]
    response.set_cookie("depth",difficulty)
    response.set_cookie("first_player",first_player)
    redirect '/'
  end

  post '/move' do
    latest_move = params[:player_move]
    service_response = return_service_response(latest_move)
    response.set_cookie(latest_move,"x")
    response.set_cookie(service_response["move"],"o")
    response.set_cookie("winner",service_response["winner"]) if service_response["winner"]
    redirect '/'
  end

  def return_service_response(latest_move)
    game_state = {"board" => cookies.select{ |key,_| key=~/^[0-9]+$/ }}
    game_state["board"][latest_move] = "x"
    game_state["depth"] = cookies[:depth]
    return AI.new.next_move(game_state)
  end

  def configuration_setting?(setting_name)
    setting_name == "first_player" or setting_name == "depth"
  end

end

if __FILE__ == $0 
  TTTDuet.run!
end
