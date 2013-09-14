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

  def self.find_game(games, id)
    if games[id.to_s]
      the_game = games[id.to_s]
    else
      the_game = Hash.new
      games[id.to_s] = the_game
    end
  end

  def self.state_update(file_contents, token, move, id)
    to_add = {
      "token" => token,
      "position" => move
    }

    all_games = file_contents["games"]

    the_game = self.find_game(all_games, id)

     if the_game["moves"]
       move_list = the_game["moves"]
     else
       move_list = []
       the_game["moves"] = move_list
     end

    new_move_list = move_list.concat([to_add])

    new_contents = {"games" => all_games}
  end

  def self.write_move(id, move, token, path="game_history.json")
    file_contents = self.compute_file_contents(path)

    new_contents = self.state_update(file_contents, token, move, id)

    File.write(path, JSON.pretty_generate(new_contents))
  end

  def self.winner_update(file_contents, winner, id)

     to_add = {
        "winner" => winner
      }

     all_games = file_contents["games"]

     the_game = self.find_game(all_games, id)

     the_game["winner"] = winner
     
     {"games" => all_games}
  end

  def self.write_winner(id,winner,file=File.open("game_history.json","r"))
    self.contents_of(file,nil) do |contents|
      self.winner_update(contents,winner,id)
    end
  end

  def self.contents_of(path, id)
    file_contents = self.compute_file_contents(path)

    new_contents = yield file_contents

    File.write(JSON.pretty_generate(new_contents))
  end
  
end
