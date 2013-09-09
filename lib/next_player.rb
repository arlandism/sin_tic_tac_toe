require_relative 'ai'
require_relative 'default_strategy'
require_relative 'game_information'

class NextPlayer

  def self.move(game_information)

    if NextPlayer.is_human?(game_information)
      return nil
    else
      info = GameInformation.new(game_information)
      response = info.service_response
      ai_move = response["ai_move"]
      return ai_move
    end

  end

  def self.is_human?(player_information)
    player_information["first_player"] == "human" and player_information["second_player"] == "human"
  end
end
