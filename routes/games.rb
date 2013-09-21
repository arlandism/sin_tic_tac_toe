require 'haml'
require 'json'

require_relative '../lib/presenters/id_presenter'

class TTTDuet < Sinatra::Base

  get '/games' do
      haml :games
  end

  get %r{/games/([0-9]+)} do
    game_id = params[:captures].first
    games = History.retrieve_or_create(TTTDuet.settings.history_path)
    queried_game = games["games"][game_id]
    response.set_cookie("id", game_id)
    response.set_cookie("moves", JSON.dump(queried_game["moves"]))
    response.set_cookie("winner", queried_game["winner"])
  end

end
