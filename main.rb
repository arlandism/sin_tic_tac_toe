require 'sinatra'
require 'sinatra/cookies'
require 'haml'

require_relative 'lib/presenters/winner_presenter'
require_relative 'lib/presenters/button_presenter'
require_relative 'lib/ai'
require_relative 'lib/cpu_move'
require_relative 'lib/next_player'

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
    first_player_move = params[:player_move]
    second_player_move = NextPlayer.move(cookies,first_player_move)
    winner = winner_on_board(first_player_move,second_player_move,cookies)
    response.set_cookie(first_player_move,"x")
    response.set_cookie(second_player_move, "o")
    response.set_cookie("winner", winner)    
    redirect '/'
  end

  def winner_on_board(move_one,move_two,current_board)
    service_response = return_service_response(move_one,move_two,current_board)
    winner = service_response["winner_on_board"]
  end

  def return_service_response(latest_move,other_move,game_info)
    game_state = {"board" => game_info.select{ |key,_| key=~/^[0-9]+$/ }}
    game_state["board"][latest_move] = "x"
    game_state["depth"] = game_info[:depth]
    AI.new.next_move(game_state)
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
    ai_move = return_service_response({},"used to stay green",{})
    response.set_cookie(ai_move["ai_move"], "o")
  end

  def game_winner(cookies)
    {"winner" => cookies["human_vs_ai_winner"]}
  end

end

if __FILE__ == $0 
  TTTDuet.run!
end
