require_relative 'ai'
require_relative 'default_strategy'

class NextPlayer

  def self.move(game_information)
    if NextPlayer.is_human?(game_information)
      return nil
    else
      game_state = {"board" => game_information.select{ |key,_| key=~/^[0-9]+$/ }}
      game_state["depth"] = self.depth(game_information)
      new_game_information = AI.new.next_move(game_state)
      ai_move = new_game_information["ai_move"]
      return ai_move
    end
  end

  def self.is_human?(player_information)
    player_information["first_player"] == "human" and player_information["second_player"] == "human"
  end
  
  def self.depth(game_information)
    DefaultStrategy.new("depth",20,game_information).attribute
  end

end
