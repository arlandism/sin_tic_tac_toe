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
    what_we_got = AI.new.next_move(game_state)
    return what_we_got
  end

  private

  def winner
    DefaultStrategy.new("winner",service_response["winner_on_board"],@current_game_information).attribute
  end

  def depth
    DefaultStrategy.new("depth",20,@current_game_information).attribute
  end

  def moves_on_board
    @current_game_information.select{ |key,_| key=~/^[0-9]+$/ }
  end

end
