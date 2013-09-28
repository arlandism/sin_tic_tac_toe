require_relative 'ai'
require_relative 'data_structures'

class GameInformation

  def initialize(current_game_information)
    @current_game_information = current_game_information
  end

  def winner_on_board
    DataStructures.presence_fetch(@current_game_information.to_hash, "winner") do
      service_response["winner_on_board"]
    end
  end

  def service_response
    AI.new.next_move({
      "board" => moves_on_board,
      "depth" => depth
    })
  end

  private

  def depth
    DataStructures.presence_fetch(@current_game_information.to_hash, "depth") {20}
  end

  def moves_on_board
    moves = @current_game_information.select{ |key,_| key=~/^[0-9]+$/ }
    moves.reduce({}) do |bucket, (key, val)|
      bucket[key.strip] = val.strip
      bucket
    end
    
  end

end
