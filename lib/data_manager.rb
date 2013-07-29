require 'json'

class DataManager

  attr_reader :socket

  def initialize(socket)
    @socket = socket
  end

  def send(data)
    @socket.puts(JSON.dump(data))
  end

  def receive
    JSON.load(@socket.gets)
  end

end
