require 'json'

class GameRecorder

  def self.write_move(id, move, token,
                      file=File.open("game_history.json","w+"))
    file_contents = JSON.load(file.read)
    to_add = {
      "token" => token,
      "position" => move
    }
    contents = file_contents || Hash.new
    all_games = contents["games"] || Hash.new
    the_game = all_games[id.to_s] || {id.to_s => {}}
    move_list = the_game["moves"] || Array.new
    new_contents = 
        {
        "moves" => 
          move_list.concat([to_add])
        }
    new_contents = {"games" => all_games}
    file.write(JSON.dump(new_contents))
    file.close
  end

  def self.write_winner(id,winner)
    ""
  end

end
