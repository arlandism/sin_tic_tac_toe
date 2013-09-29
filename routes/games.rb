require 'haml'
require 'json'

require_relative '../lib/presenters/id_presenter'

class TTTDuet < Sinatra::Base

  get '/games' do
    @games = HistoryAccessor.retrieve_or_create(settings.history_path)["games"]
    if @games.keys
      haml :games
    else
      haml :no_history_found
    end
  end

  get %r{/games/([0-9]+)} do
    game_id = params[:captures].first
    response.set_cookie("id", game_id)
    @game = HistoryAccessor.game_by_id(settings.history_path, game_id)
    haml :game
  end

end
