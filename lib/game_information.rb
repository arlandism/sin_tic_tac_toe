require_relative 'ai'

class GameInformation

  def initialize(current_game_information)
    @current_game_information = current_game_information
  end

  def winner_on_board
    winner = service_response["winner_on_board"]
  end

  def service_response
    game_state = {"board" => moves_on_board}
    game_state["depth"] = @current_game_information["depth"]|| 20
    AI.new.next_move(game_state)
  end

  private

  def moves_on_board
    @current_game_information.select{ |key,_| key=~/^[0-9]+$/ }
  end

end
