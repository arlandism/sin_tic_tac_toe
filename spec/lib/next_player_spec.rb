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

    it "does some processing before calling AI" do
      pre_processed = {"depth" => 20}
      post_processed = {"depth" => 20, "board" => {}}

      @ai.should_receive(:next_move).with(post_processed).and_return({})
      NextPlayer.move(pre_processed)
    end
  end
end
