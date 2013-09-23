require 'haml'

require_relative '../lib/cpu_move'
require_relative '../lib/presenters/button_presenter'
require_relative '../lib/presenters/winner_presenter'

class TTTDuet < Sinatra::Base

  get '/' do
    if CpuMove.should_place(cookies.to_hash) 
      place_move_on_board(next_player_move, token(cookies))
    end
    haml :index 
  end

end
