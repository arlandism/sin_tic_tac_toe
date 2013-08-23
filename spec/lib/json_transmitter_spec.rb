require 'rack/test'
require 'json'
require 'json_transmitter'

describe 'main' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe 'JsonTransmitter' do

    describe "initialization" do

      it "takes a socket" do
        my_socket = "socket"
        transmitter = JsonTransmitter.new(my_socket)
        transmitter.socket.should be my_socket
      end
    end

    describe "send and receive" do

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

      before(:each) do
        @socket = double()
        @transmitter = JsonTransmitter.new @socket
      end
    end
  end
end
