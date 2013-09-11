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
    move_structure = contents[id.to_s] || Hash.new
    move_list = move_structure["moves"] || Array.new
    new_contents = {
        "moves" => 
          move_list.concat([to_add])
    }
    contents[id.to_s] = new_contents
    file.write(JSON.dump(contents))
    file.close
  end

  def self.write_winner(id,winner)
    ""
  end

end
