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

    it "gets data over its connection" do
      @connection_socket.puts("Hi socket!")
      data_received? "Hi socket!"
    end

    it "puts data over its connection" do
      @socket.puts "Hi server!"
      @connection_socket.gets.should == "Hi server!\n"
    end

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

    def data_received?(data)
      @socket.gets.should == data += "\n" 
    end

    def connect_and_return_connection_socket
      initiate_handshake! @server
      client = @server.accept
    end

  end
end
