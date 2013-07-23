
class ClientSocket
  attr_reader :port
  attr_reader :connected

  def initialize(port=5000)
    @port = port
    @connected = false
  end

  def connect(socket)
    @connected = true
  end
end
