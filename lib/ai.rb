require_relative 'client'
require_relative 'json_transmitter'

class AI
  
  attr_reader :winner

  def initialize
    socket = ClientSocket.new 
    socket.connect!
    @transmitter = JsonTransmitter.new socket
  end

  def next_move(board_state)
     updated_game_state = Hash.new
     @transmitter.send(board_state)
     updated_game_state["move"] = @transmitter.receive
     updated_game_state["winner"] = @transmitter.receive
     return updated_game_state
  end

end


