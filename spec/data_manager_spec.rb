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
    @server = TCPServer.open(6000)
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

    it "sends JSON over the wire" do
      run_server!
      socket = TCPSocket.new("localhost",6000)
      dm = DataManager.new(socket)
      to_send = "json_string"
    end
  end
end
