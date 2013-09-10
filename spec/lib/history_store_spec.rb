require_relative '../../lib/history_store'

describe HistoryStore do

  describe ".new_game" do
    
    it "creates a new game" do
      game = HistoryStore.new_game
      game.should_not == nil
    end

  end

  describe ".record_move" do
  
    it "records a move to game with given id" do
      game = HistoryStore.new_game
      HistoryStore.record_move(game.id,3,"x")
      game.move_at(3).should == "x"
    end

  end

end
