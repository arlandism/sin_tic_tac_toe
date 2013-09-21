require 'haml'
require 'json'

require_relative '../lib/presenters/id_presenter'

class TTTDuet < Sinatra::Base

  get '/games' do
    haml :games
  end

  get %r{/games/([0-9]+)} do
    game_id = params[:captures].first
    response.set_cookie("id", game_id)
    games = History.retrieve_or_create(settings.history_path)
    @game = GameRepository.game_by_id(games, game_id)
    haml :game
  end

end
