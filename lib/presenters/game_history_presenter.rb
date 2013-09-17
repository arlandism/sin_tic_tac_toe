require_relative '../game_recorder'

class GameHistoryPresenter

  def self.show_games
    games = GameRecorder.compute_file_contents("game_history.json")["games"]
    game_string = ""
    games.keys.each do |id|
      game_string += self.game_header(id)
      if games[id]["moves"]
        game_string += self.move_string(games[id]["moves"])
      end
    end
    game_string
  end

  private

  def self.game_header(id)
    "<div>Game #{id}</div>"
  end

  def self.move_string(move_list)
    move_string = "<ol>"
    move_list.each do |move|
      move_string += "<li>#{move["token"]} moved to #{move["position"]}</li>"   
      end
    move_string += "</ol>"
    move_string
  end
end



