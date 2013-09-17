require_relative '../game_recorder'

class GameHistoryPresenter

  def self.show_games
    games = GameRecorder.compute_file_contents("game_history.json")["games"]
    games_presentation = ""
    game_ids = games.keys
    game_ids.each do |id|
      games_presentation += self.game_header(id)
      games_presentation += self.game_body(games[id]) 
    end
    games_presentation
  end

  private

  def self.game_header(id)
    "<div>Game #{id}</div>"
  end

  def self.game_body(game)
    body = ""
    if game["moves"]
        body += self.move_list(game["moves"])
    elsif game["winner"]
        body += self.winner(game["winner"]) 
    end
    body
  end

  def self.winner(winner)
    "#{winner} won"
  end

  def self.move_list(move_list)
    move_list_string = "<ol>"
    move_list.each do |move|
      move_list_string += "<li>#{move["token"]} moved to #{move["position"]}</li>"   
      end
    move_list_string += "</ol>"
    move_list_string
  end
end



