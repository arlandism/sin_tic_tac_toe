require 'rack/test'
require 'socket'
require 'json'
require 'json_transmitter'

describe 'main' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def run_server!
    @port = Random.rand((2000..60000))
    @server = TCPServer.open(@port)
  end

  def close_socket!(socket)
    socket.close
  end

  describe 'JsonTransmitter' do

    describe "initialization" do

      it "takes a socket" do
        my_socket = "socket"
        dm = JsonTransmitter.new(my_socket)
        dm.socket.should be my_socket
      end
    end

    describe "data transmission" do

      it "sends JSON over the socket" do
        conn = @server.accept
        message = "json_string"
        @manager.send(message)
        received = conn.gets
        JSON.load(received).should == message
      end

      it "parses the JSON it receives" do
        conn = @server.accept
        message = "Did you get this?"
        conn.puts(JSON.dump(message))
        @manager.receive.should == message 
      end

      before(:each) do
        run_server!
        @socket = TCPSocket.new("localhost",@port)
        @manager = JsonTransmitter.new(@socket)
      end
    end

  end
end
