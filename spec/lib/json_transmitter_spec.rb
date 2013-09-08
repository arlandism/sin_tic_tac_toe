require 'json'
require 'json_transmitter'

describe 'JsonTransmitter' do

  describe "send and receive" do

    before(:each) do
      @socket = double()
      @transmitter = JsonTransmitter.new @socket
    end

    it "calls its socket for sending" do
      @socket.should_receive(:puts)
      @transmitter.send("")
    end

    it "accesses its socket's gets method" do
      @socket.should_receive(:gets)
      @transmitter.receive
    end

    it "transforms info to json before sending" do
      greeting = "Hello"
      jsonified_greeting = JSON.dump(greeting)
      @socket.should_receive(:puts).with(jsonified_greeting)
      @transmitter.send(greeting)
    end

    it "decodes info from json upon receipt" do
      message = "Decode me!"
      jsonified_message = JSON.dump(message)
      @socket.stub(:gets) {jsonified_message}
      @transmitter.receive.should == message
    end

    context "newlines"
    it "knows how to deal with junk" do
      junk = JSON.dump("blah") + "\n"
      non_junk = "blah"
      @socket.stub(:gets).and_return(junk)
      @transmitter.receive.should == non_junk
    end

    context "spaces"
    it "knows how to deal with junk" do
      junk = JSON.dump("ha") + " "
      non_junk = "ha"
      @socket.stub(:gets).and_return(junk)
      @transmitter.receive.should == non_junk
    end
  end
end
