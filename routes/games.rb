require 'haml'

require_relative '../lib/presenters/id_presenter'

class TTTDuet < Sinatra::Base

  get '/games' do
      haml :games
  end

  get %r{/games/[0-9]+} do
  
  end

end
