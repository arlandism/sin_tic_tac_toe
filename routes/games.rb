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
  end

end
