require_relative 'client'
require_relative 'json_transmitter'

class AI
  
  def initialize
    socket = ClientSocket.new 6000
    socket.connect!
    @transmitter = JsonTransmitter.new socket
  end

  def next_move(board_state)
     @transmitter.send(board_state)
     @transmitter.receive
  end

end


