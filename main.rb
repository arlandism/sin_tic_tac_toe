require 'sinatra'
require 'haml'
require_relative 'lib/winner_presenter'
require_relative 'lib/button_presenter'
require_relative 'lib/ai'
require_relative 'lib/helpers'

class TTTDuet < Sinatra::Base

  get '/' do
    @board = request.cookies
    haml :index 
  end

  get '/clear' do
    request.cookies.keys.each do |key|
      response.delete_cookie(key)
    end
    redirect '/'
  end

  get '/config' do
    haml :config
  end

  post '/config' do
    response.set_cookie("depth",params[:difficulty])
    redirect '/'
  end

  post '/move' do
    move = params[:player_move]
    utilize_helpers(request.cookies,response, move)
    redirect '/'
  end

  def utilize_helpers(cookies, response, move)
    response.set_cookie(move, "x")
    human_move = {move => "x"}
    board_state = Helpers.add_hashes(cookies, human_move)
    game_info = Helpers.call_ai(AI.new, {"board"=> board_state}) 
    comp_move = Helpers.ai_move(game_info)
    response.set_cookie(comp_move, "o")
    set_winner_if_exists(response,game_info)
  end

  def set_winner_if_exists(response,game_info)
    if game_info.include?("winner")
      response.set_cookie("winner", game_info["winner"])
    end
  end
end

if __FILE__ == $0
  TTTDuet.run!
end
