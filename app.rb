require 'sinatra'
require 'sinatra/cookies'
require 'haml'

require_relative 'lib/presenters/winner_presenter'
require_relative 'lib/presenters/button_presenter'
require_relative 'lib/cpu_move'
require_relative 'lib/next_player'
require_relative 'lib/game_information'
require_relative 'lib/game_recorder'

class TTTDuet < Sinatra::Base
  helpers Sinatra::Cookies

  get '/' do
    if CpuMove.should_place(cookies.to_hash) 
      place_move_on_board(next_player_move, token(cookies))
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
    token_one = token(cookies)
    place_move_on_board(first_player_move,token_one)

    token_two = token(cookies)
    place_move_on_board(next_player_move,token_two)

    place_winner_on_board
    redirect '/'
  end

  def token(game_information)
    x_count = game_information.values.count("x")
    o_count = game_information.values.count("o")
    if x_count > o_count
      return "o"
    else
      return "x"
    end
  end

  def place_move_on_board(move,token)
    response.set_cookie(move,token)
    GameRecorder.write_to_history({move => token})
  end

  def place_winner_on_board
    winner = GameInformation.new(cookies).winner_on_board
    response.set_cookie("winner",winner)
    GameRecorder.write_to_history({"winner" => winner})
  end

  def first_player_move 
    params[:player_move]
  end

  def next_player_move
    NextPlayer.move(cookies) 
  end

  def configuration_setting?(setting_name)
    configurations = ["first_player", "second_player", "depth"]
    configurations.include?(setting_name)
  end
  
  def delete_non_configuration_cookies!
    cookies.each_key do |cookie| 
      response.delete_cookie(cookie) unless configuration_setting?(cookie) 
    end
  end

end

if __FILE__ == $0 
  TTTDuet.run!
end
