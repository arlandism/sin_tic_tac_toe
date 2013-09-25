require_relative '../lib/next_player'
require_relative '../lib/game_information'
require_relative '../lib/history'

class TTTDuet < Sinatra::Base

  post '/move' do
    id = cookies["id"] || FileHistory.next_id(settings.history_path)
    response.set_cookie("id",id)
    token_one = token(cookies)
    place_move_on_board(first_player_move,token_one)

    token_two = token(cookies)
    place_move_on_board(next_player_move,token_two)

    place_winner_on_board
    redirect '/'
  end

  def place_move_on_board(move,token)
    response.set_cookie(move,token)
    id = cookies["id"].to_i
    FileHistory.write_move(id, move.to_i, token, settings.history_path)
  end
 
 def place_winner_on_board
    winner = GameInformation.new(cookies).winner_on_board
    response.set_cookie("winner",winner)
    id = cookies["id"].to_i
    FileHistory.write_winner(id,winner, settings.history_path)
  end

  def first_player_move 
    params[:player_move]
  end

  def next_player_move
    NextPlayer.move(cookies) 
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

end
