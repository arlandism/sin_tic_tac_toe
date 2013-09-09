require_relative '../../lib/next_player'
require_relative '../../lib/ai'

describe NextPlayer do

  describe ".is_human?" do
    
    it "returns true if both players are human" do
      players = {"first_player" => "human", "second_player" => "human"}
      NextPlayer.is_human?(players).should == true
    end

    it "returns false if one of the players is computer" do
      players = {"first_player" => "computer", "second_player" => "human"}
      NextPlayer.is_human?(players).should == false
    end
  end

  describe ".move" do

    before(:each) do
      @ai = double(:ai)
      AI.stub(:new).and_return(@ai)
    end

    it "calls AI when is_human? returns false" do
      NextPlayer.stub(:is_human?).and_return(false) 

      @ai.should_receive(:next_move).and_return({})

      board = {"board" => {}}
      NextPlayer.move(board)
    end

    it "returns what AI gives it" do
      NextPlayer.stub(:is_human?).and_return(false)

      @ai.should_receive(:next_move).and_return({"ai_move" => 17})

      NextPlayer.move({}).should == 17
   end

    it "returns nil for a human move" do
      NextPlayer.stub(:is_human?).and_return(true)
      NextPlayer.move({}).should == nil
    end

  end
end
  describe "integration with GameInformation" do

    it "delegates to GameInformation for AI response" do
      game_state = {"1" => "x", "depth" => 20}
      mock_game_info = double(:mock_game_info)
      GameInformation.should_receive(:new).with(game_state).and_return(mock_game_info)
      mock_game_info.should_receive(:service_response).and_return("ai_move" => 3)
      NextPlayer.move(game_state).should == 3
    end
  end
