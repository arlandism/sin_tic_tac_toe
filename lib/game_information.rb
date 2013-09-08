require_relative 'ai'
require_relative 'default_strategy'

class GameInformation

  def initialize(current_game_information)
    @current_game_information = current_game_information
  end

  def winner_on_board
    winner  
  end

  def service_response
    game_state = {"board" => moves_on_board}
    game_state["depth"] = depth
    AI.new.next_move(game_state)
  end

  private

  def winner
    winner_from_service = service_response["winner_on_board"]
    DefaultStrategy.new("winner",winner_from_service,@current_game_information).attribute
  end

  def depth
    DefaultStrategy.new("depth",20,@current_game_information).attribute
  end

  def moves_on_board
    moves = @current_game_information.select{ |key,_| key=~/^[0-9]+$/ }
    sanitized_moves = Hash.new 
    moves.each_pair { |key, value| sanitized_moves[key.strip] = value.strip }
    sanitized_moves
  end

end
