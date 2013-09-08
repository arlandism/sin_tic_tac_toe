require_relative '../../lib/game_information'
require_relative '../../lib/ai'

describe GameInformation do

   before(:each) do
      @ai = double(:AI)
      AI.stub(:new).and_return(@ai)
    end

  describe "#service_response" do

    it "passes information to AI" do
      board_state = {"1" => "x", "depth" => 2}
      @ai.should_receive(:next_move).with({"board" => {"1" => "x"}, "depth" => 2})

      GameInformation.new(board_state).service_response 
    end 
    
  end

  describe "#winner_on_board" do
    
    it "returns the winner that AI gave it" do
      @ai.stub(:next_move).and_return("winner_on_board" => "me")

      GameInformation.new({}).winner_on_board.should == "me"
    end
    
    it "calls AI if received winner blank or nil" do
      game_state = {"winner" => nil}
      @ai.should_receive(:next_move).and_return("winner_on_board" => "x")
      GameInformation.new(game_state).winner_on_board 
    end
  end
  
  describe "integration with DefaultStrategy" do
    it "defaults the depth if it can't find it" do
      board_state = {}
      @ai.should_receive(:next_move).with({"board" => {}, "depth" => 20})

      GameInformation.new(board_state).service_response
    end

    it "defaults the depth if it's an empty string" do
      game_state = {"depth" => ""}
      @ai.should_receive(:next_move).with({"board" => {}, "depth" => 20})

      GameInformation.new(game_state).service_response
    end

   it "sends back the same winner if there's already one stored" do
      game_state = {"winner" => "x"}
      @ai.stub(:next_move).and_return("winner_on_board" => "new winner")

      GameInformation.new(game_state).winner_on_board.should == "x"
    end
  end
end
