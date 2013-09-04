require 'sinatra'
require 'sinatra/cookies'
require 'haml'

require_relative 'lib/presenters/winner_presenter'
require_relative 'lib/presenters/button_presenter'
require_relative 'lib/ai'
require_relative 'lib/cpu_move'

class TTTDuet < Sinatra::Base
  helpers Sinatra::Cookies

  get '/' do
    if CpuMove.should_place(cookies.to_hash) 
      add_cpu_move
    end
    haml :index 
  end

  get '/clear' do
    delete_non_configuration_cookies!
    redirect '/'
  end

  get '/config' do
    haml :config
  end

  post '/config' do
    difficulty = params[:depth]
    first_player = params[:first_player]
    second_player = params[:second_player]
    response.set_cookie("depth",difficulty)
    response.set_cookie("first_player",first_player)
    response.set_cookie("second_player",second_player)
    redirect '/'
  end

  post '/move' do
    human_move = params[:player_move]
    state_of_human_vs_ai_game = return_service_response(human_move)
    ai_move = state_of_human_vs_ai_game["ai_move"]
    winner_of_human_vs_ai_game = state_of_human_vs_ai_game["winner_after_ai_move"]
    response.set_cookie(human_move,"x")
    if humans_only(cookies)
      response.set_cookie(4,"o")
    else
      response.set_cookie(ai_move,"o")
    end
    response.set_cookie("human_vs_ai_winner",winner_of_human_vs_ai_game)    
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
  
  def delete_non_configuration_cookies!
    cookies.each_key do |cookie| 
      response.delete_cookie(cookie) unless configuration_setting?(cookie) 
    end
  end

  def add_cpu_move
    ai_move = return_service_response({})
    response.set_cookie(ai_move["ai_move"], "o")
  end

  def humans_only(player_information)
    player_information["first_player"] == "human" and player_information["second_player"] == "human"
  end

  def game_winner(cookies)
    {"winner" => cookies["human_vs_ai_winner"]}
  end

end

if __FILE__ == $0 
  TTTDuet.run!
end
