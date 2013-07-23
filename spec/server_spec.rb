require 'client'

describe 'ClientSocket' do
  before(:each) do
   @socket = ClientSocket.new 
  end

  describe "initialization" do
   it "sets a default port" do
     @socket.port.should be 5000
   end 
  end
end
