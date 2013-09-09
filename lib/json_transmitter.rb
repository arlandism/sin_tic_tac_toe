require 'json'

class JsonTransmitter

  attr_reader :stream

  def initialize(stream)
    @stream = stream
  end

  def send(data)
    data = JSON.dump(data)
    @stream.puts(data) 
  end

  def receive
    data = @stream.gets
    JSON.load(data)
  end

end
