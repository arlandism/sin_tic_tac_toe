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
    data = @socket.gets
    data = try_substitution(data)
    JSON.load(data)
  end

  def try_substitution(data)
    if data.class.eql?(nil)
      data = ""
    end
    begin 
      data = data.tr("\n","")
    rescue
      data = ""
    end
    data
  end

end
