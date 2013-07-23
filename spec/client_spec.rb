require 'client'

describe 'ClientSocket' do
  before(:each) do
   @socket = ClientSocket.new 
  end

  describe "initialization" do
    it "sets a default port" do
      @socket.port.should be 5000
    end 

    it "sets connected var to false" do
      @socket.connected.should be false
    end

    it "allows a port to be set" do
      socket = ClientSocket.new 3000
      socket.port.should be 3000
    end
  end

  describe "connect" do
    it "connects to another socket" do
      @socket.connect("").should be true
    end
  end
end

