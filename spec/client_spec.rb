require 'client'

describe 'ClientSocket' do

  describe "initialization" do
    it "sets a default port" do
      ClientSocket.new.port.should be 5000
    end 

    it "sets a default hostname" do
      ClientSocket.new.hostname.should == "localhost"
    end

    it "sets connected var to false" do
      ClientSocket.new.connected.should be false
    end

    it "allows a port to be specified" do
      socket = ClientSocket.new 3000
      socket.port.should be 3000
    end
  end

  describe "data flow" do

    before(:each) do
      @socket = ClientSocket.new(Random.rand(2000..65000))
      @server = TCPServer.open(@socket.port)
      @connection_socket = connect_and_return_connection_socket
    end

    after(:each) do
      @socket.close!
      @connection_socket.close
    end

    def initiate_handshake!(server)
      server.listen(1)
      @socket.connect!
    end

    def data_was_sent?(data)
      @socket.data.should == data += "\n" 
    end

    def connect_and_return_connection_socket
      initiate_handshake! @server
      client = @server.accept
    end

    it "connects to given host on port" do
      @connection_socket.puts("Hi socket!")
      data_was_sent? "Hi socket!"
    end

    it "sends data over its connection" do
      @socket.send "Hi server!"
      @connection_socket.gets.should == "Hi server!\n"
    end
  end
end
