class GameState

  def self.new_move(games, token, move, id)
    to_add = {
      "token" => token,
      "position" => move
    }

    all_games = games["games"]

    the_game = self.find_game(all_games, id)

     if the_game["moves"]
       move_list = the_game["moves"]
     else
       move_list = []
       the_game["moves"] = move_list
     end

    new_move_list = move_list.concat([to_add]) if to_add["position"] != 0

    {"games" => all_games}
  end

  def self.new_winner(games, winner, id)

     to_add = {
        "winner" => winner
      }

     all_games = games["games"]

     the_game = self.find_game(all_games, id)

     the_game["winner"] = winner
     
     {"games" => all_games}
  end
  
  private

  def self.find_game(games, id)
    if games[id.to_s]
      the_game = games[id.to_s]
    else
      the_game = Hash.new
      games[id.to_s] = the_game
    end
  end

end
