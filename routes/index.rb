require 'haml'

require_relative '../lib/cpu_move'
require_relative '../lib/presenters/button_presenter'
require_relative '../lib/presenters/winner_presenter'

class TTTDuet < Sinatra::Base

  get '/' do
    id = cookies["id"] || History.next_id(settings.history_path)
    response.set_cookie("id", id)
    if CpuMove.should_place(cookies.to_hash) 
      place_move_on_board(next_player_move, token(cookies))
    end
    haml :index 
  end

end
