require 'sinatra'
require 'sinatra/cookies'
require 'haml'

require_relative 'lib/presenters/winner_presenter'
require_relative 'lib/presenters/button_presenter'
require_relative 'lib/ai'
require_relative 'lib/cpu_move'
require_relative 'lib/next_player'
require_relative 'lib/game_information'

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
    response.set_cookie(first_player_move,"x")
    winner = GameInformation.new(cookies).winner_on_board
    response.set_cookie(second_player_move(winner), "o")
    response.set_cookie("winner", winner)    
    redirect '/'
  end

  def first_player_move 
    params[:player_move]
  end

  def second_player_move(winner)
    second_player_move = NextPlayer.move(cookies) if winner == nil
    return second_player_move
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
    ai_move = NextPlayer.move(cookies) 
    response.set_cookie(ai_move, "o")
  end

end

if __FILE__ == $0 
  TTTDuet.run!
end
