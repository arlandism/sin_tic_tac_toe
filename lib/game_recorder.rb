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
    games = contents["games"] || {"games" => {}}
    move_structure = games[id.to_s] || Hash.new
    move_list = move_structure["moves"] || Array.new
    new_contents = {
      id.to_s =>
        {
        "moves" => 
          move_list.concat([to_add])
        }
      }
    contents["games"] = new_contents
    file.write(JSON.dump(contents))
    file.close
  end

  def self.write_winner(id,winner)
    ""
  end

end
