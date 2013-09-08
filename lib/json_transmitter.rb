require 'json'

class JsonTransmitter

  attr_reader :socket

  def initialize(socket)
    @socket = socket
  end

  def send(data)
    data = JSON.dump(data)
    @socket.puts(data) 
  end

  def receive
    data = @socket.gets.to_s.strip
    JSON.load(data)
  end

end
