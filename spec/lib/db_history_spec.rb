require_relative '../../lib/db_history'

describe DBHistory do

  let(:id)   { 2 }
  let(:path) { "bar" }

  describe ".retrieve_or_create" do

    it "creates a 'games' data structure if it doesn't exist" do
      DatabaseIO.stub(:read).with(path).and_return(nil)
      DBHistory.retrieve_or_create(path).should == {"games" => {}}
    end

    it "retrieves what lives at path and hands it off to interpreter" do
      DatabaseIO.stub(:read).with(path).and_return(3)
      DBInterpreter.should_receive(:translate_games).with(3).and_return(7)
      DBHistory.retrieve_or_create(path).should == 7
    end
  end

  describe ".write_move" do

    it "writes moves to its IO" do
      move = 4
      token = "x"
      DatabaseIO.should_receive(:write_move).with(path, id, move, token)
      DBHistory.write_move(id, move, token, path)
    end
  end

  describe ".write_winner" do

    it "writes winners to its IO" do
      winner = "me!"
      DatabaseIO.should_receive(:write_winner).with(path, id, winner)
      DBHistory.write_winner(id, winner, path)
    end
  end

  describe ".next_id" do

    it "returns what DatabaseIO gives it" do
      DatabaseIO.should_receive(:next_id).and_return(17)
      DBHistory.next_id("bar").should == 17
    end
  end

  describe ".game_by_id" do
    
    it "delegates to DBInterpreter and DatabaseIO" do
      game = ""
      DatabaseIO.should_receive(:game_by_id).with(id).and_return(game)
      DBInterpreter.should_receive(:translate_game).with(game).and_return("game")
      DBHistory.game_by_id(path, id).should == "game"
    end
  end
end
