require_relative '../../lib/db_history'

describe DBHistory do

  let(:id) { 2 }

  describe ".retrieve_or_create" do

    it "creates a 'games' data structure if it doesn't exist" do
      path = "/baz"
      DatabaseIO.stub(:read).with(path).and_return(nil)
      DBHistory.retrieve_or_create(path).should == {"games" => {}}
    end

    it "retrieves what lives at path" do
      path = "hello"
      DatabaseIO.stub(:read).with(path).and_return(3)
      DBHistory.retrieve_or_create(path).should == 3
    end
  end

  describe ".write_move" do

    it "writes moves to its IO" do
      path = "yo"
      move = 4
      token = "x"
      DatabaseIO.should_receive(:write_move).with(path, id, move, token)
      DBHistory.write_move(id, move, token, path)
    end
  end

  describe ".write_winner" do

    it "writes winners to its IO" do
      path = "yo"
      winner = "me!"
      DatabaseIO.should_receive(:write_winner).with(path, id, winner)
      DBHistory.write_winner(id, winner, path)
    end
  end

  describe ".game_by_id" do
    
    it "delegates to DBInterpreter and DatabaseIO" do
      fake_path = "bar"
      game = ""
      DatabaseIO.should_receive(:game_by_id).with(id).and_return(game)
      DBInterpreter.should_receive(:translate_game).with(game).and_return("game")
      DBHistory.game_by_id(fake_path, id).should == "game"
    end
  end
end
