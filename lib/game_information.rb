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
    game_state["depth"] = depth
    what_we_got = AI.new.next_move(game_state)
    return what_we_got
  end

  private

  def depth
    extracted_depth = @current_game_information["depth"]
    if extracted_depth == nil or extracted_depth == ""
      extracted_depth = 20
    end
    extracted_depth
  end

  def moves_on_board
    @current_game_information.select{ |key,_| key=~/^[0-9]+$/ }
  end

end
