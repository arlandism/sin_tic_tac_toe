require_relative 'ai'

class NextPlayer

  def self.move(game_information)
    if NextPlayer.is_human?(game_information)
      return nil
    else
      game_state = {"board" => game_information.select{ |key,_| key=~/^[0-9]+$/ }}
      game_state["depth"] = game_information["depth"]
      new_game_information = AI.new.next_move(game_state)
      ai_move = new_game_information["ai_move"]
      return ai_move
    end
  end

  def self.is_human?(player_information)
    player_information["first_player"] == "human" and player_information["second_player"] == "human"
  end

end
