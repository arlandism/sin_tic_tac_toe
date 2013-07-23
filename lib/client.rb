
class ClientSocket
  attr_reader :port

  def initialize(port=5000)
    @port = port
  end
end
