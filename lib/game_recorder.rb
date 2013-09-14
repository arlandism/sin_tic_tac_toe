require 'json'

class GameRecorder

  DEFAULT = {"games" => {}}

  def self.compute_file_contents(path)
    begin
      file_contents = JSON.parse(File.read(path)) 
    rescue JSON::ParserError
      file_contents = DEFAULT
    end
  end

  def self.write_move(id, move, token, path="game_history.json")
    self.contents_of_file_at(path) do |contents|
      GameState.after_new_move(contents, token, move, id)
    end
  end

  def self.write_winner(id,winner,path="game_history.json")
    self.contents_of_file_at(path) do |contents|
      GameState.after_new_winner(contents,winner,id)
    end
  end

  def self.contents_of_file_at(path)
    file_contents = self.compute_file_contents(path)

    new_contents = yield file_contents

    File.write(path,JSON.pretty_generate(new_contents))
  end
  
end

class GameState

  def self.after_new_move(games, token, move, id)
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

    new_move_list = move_list.concat([to_add])

    games_after_update = {"games" => all_games}
  end

  def self.find_game(games, id)
    if games[id.to_s]
      the_game = games[id.to_s]
    else
      the_game = Hash.new
      games[id.to_s] = the_game
    end
  end

  def self.after_new_winner(games, winner, id)

     to_add = {
        "winner" => winner
      }

     all_games = games["games"]

     the_game = self.find_game(all_games, id)

     the_game["winner"] = winner
     
     {"games" => all_games}
  end

end
