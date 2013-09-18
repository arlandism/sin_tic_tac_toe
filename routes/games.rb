require 'haml'

require_relative '../lib/presenters/id_presenter'

class TTTDuet < Sinatra::Base

  get '/games' do
      haml :games
  end

end
