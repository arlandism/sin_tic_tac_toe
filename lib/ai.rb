require_relative 'client'
require_relative 'json_transmitter'

class AI
  
  def initialize
    socket = ClientSocket.new 
    socket.connect!
    @transmitter = JsonTransmitter.new socket
  end

  def next_move(board_state)
     @transmitter.send(board_state)
     updated_game_state = @transmitter.receive
     return updated_game_state
  end

end


