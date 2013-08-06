require './lib/ai'

describe AI do

  before(:each) do
    @socket = mock(:socket)
    @transmitter = mock(:transmitter)
    JsonTransmitter.stub(:new).and_return(@transmitter)
    ClientSocket.any_instance.stub(:connect!)
    @ai = AI.new
    end

  it "should instantiate and connect a socket" do
    ClientSocket.should_receive(:new).and_return(@socket)
    @socket.should_receive(:connect!)
    AI.new
  end

  it "should instantiate a JsonTransmitter" do
    ClientSocket.stub(:new).and_return(@socket)
    @socket.stub(:connect!)
    JsonTransmitter.should_receive(:new).with(@socket)
    AI.new
  end

  describe "#next_move" do
    
    it "sends a message through its transmitter" do
      message = "message for you"
      @transmitter.should_receive(:send).with(message)
      @transmitter.stub(:receive)
      @ai.next_move(message)
    end

    it "sends another message" do
      message = "hahahaha"
      @transmitter.should_receive(:send).with(message)
      @transmitter.stub(:receive)
      @ai.next_move(message)
    end

    it "receives a message through its transmitter" do
      @transmitter.stub(:send)
      @transmitter.should_receive(:receive).at_least(:once)
      @ai.next_move("haha")
    end

    it "returns what came through the transmitter" do
      message = "stuff that should come through"
      @transmitter.stub(:send)
      @transmitter.stub(:receive).and_return(message) 
      @ai.next_move("whatever")["move"].should == message 
    end

    context "with o as winner"
    it "stores the winner from the transmitter" do
      @transmitter.stub(:receive).and_return(1,"o")
      @transmitter.stub(:send)
      game_info = @ai.next_move({})
      game_info["move"].should == 1
      game_info["winner"].should == "o"
    end
  end

    context "with x as winner"
    it "stores other winner from transmitter" do
      @transmitter.stub(:receive).and_return(2,"x")
      @transmitter.stub(:send)
      info = @ai.next_move({})
      info["move"].should == 2
  end
end
