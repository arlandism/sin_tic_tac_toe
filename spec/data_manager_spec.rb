require 'rack/test'
require 'socket'
require 'json'
require 'data_manager'

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

  describe "DataManager initialization" do
    it "takes a socket" do
      my_socket = "socket"
      dm = DataManager.new(my_socket)
      dm.socket.should be my_socket
    end
  end

  describe "DataManager data transmission" do

    before(:each) do
      run_server!
      @socket = TCPSocket.new("localhost",@port)
      @manager = DataManager.new(@socket)
    end

    it "sends JSON over the wire" do
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
  end
end
