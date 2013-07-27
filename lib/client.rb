
class ClientSocket
  attr_reader :connected, :port, :hostname

  def initialize(port=5000,hostname="localhost")
    @port = port
    @hostname = hostname
    @connected = false
  end

  def connect!
    @socket = TCPSocket.open @hostname, @port
    @connected = true
  end

  def close!
    @socket.close
    @connected = false
  end

  def data
    received_data = @socket.gets
  end

  def send(data)
    @socket.puts data 
  end

end
