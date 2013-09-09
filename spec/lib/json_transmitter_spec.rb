require 'json'
require 'json_transmitter'

describe 'JsonTransmitter' do

  describe "send and receive" do

    before(:each) do
      @stream = double()
      @transmitter = JsonTransmitter.new @stream
    end

    it "calls its stream for sending" do
      @stream.should_receive(:puts)
      @transmitter.send("")
    end

    it "accesses its stream's gets method" do
      @stream.should_receive(:gets)
      @transmitter.receive
    end

    it "transforms info to json before sending" do
      greeting = "Hello"
      jsonified_greeting = JSON.dump(greeting)
      @stream.should_receive(:puts).with(jsonified_greeting)
      @transmitter.send(greeting)
    end

    it "decodes info from json upon receipt" do
      message = "Decode me!"
      jsonified_message = JSON.dump(message)
      @stream.stub(:gets) {jsonified_message}
      @transmitter.receive.should == message
    end

    context "newlines"
    it "knows how to deal with junk" do
      junk = JSON.dump("blah") + "\n"
      non_junk = "blah"
      @stream.stub(:gets).and_return(junk)
      @transmitter.receive.should == non_junk
    end

    context "spaces"
    it "knows how to deal with junk" do
      junk = JSON.dump("ha") + " "
      non_junk = "ha"
      @stream.stub(:gets).and_return(junk)
      @transmitter.receive.should == non_junk
    end
  end
end
