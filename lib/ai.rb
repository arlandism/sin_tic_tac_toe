class AI
  
  def initialize
    socket = ClientSocket.new 6000
    socket.connect!
    @transmitter = JsonTransmitter.new socket
  end

  def next_move(board_state)
     @transmitter.send("message for you")
     @transmitter.receive
  end

end


