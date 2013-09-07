require_relative 'ai'

class GameInformation

  def initialize(move_one, move_two, current_game_information)
    @move_one = move_one
    @move_two = move_two
    @current_game_information = current_game_information
  end

  def winner_on_board
    game_information = service_response(@move_one,@move_two)
    winner = game_information["winner_on_board"]
  end

  def service_response(latest_move,other_move)
    game_state = {"board" => moves_on_board}
    game_state["board"][latest_move] = "x"
    game_state["depth"] = @current_game_information[:depth]
    AI.new.next_move(game_state)
  end

  private

  def moves_on_board
    @current_game_information.select{ |key,_| key=~/^[0-9]+$/ }
  end

end
