require 'json'
require_relative '../../lib/game_recorder'

describe GameRecorder do

  describe ".compute_file_contents" do

    it "creates a 'games' data structure if it doesn't exist at path" do
      expected = {"games" => {}}
      path = "bar" 
      File.stub(:read).with(path).and_return("")
      GameRecorder.compute_file_contents(path).should == expected
    end
    
    it "overwrites what used to exist at path" do
      id = "1"
      path = "foo"
      File.stub(:read).with(path).and_return("")
      GameState.stub(:new_move).and_return(["new"])
      File.should_receive(:write).with(path, JSON.pretty_generate(["new"]))
      GameRecorder.write_move(id, 5, "o", path)
    end
    
  end

  describe ".write_winner" do
    
    it "delegates to GameState" do
      
      path = "??"
      winner = "x"
      id = "3"
      File.stub(:read).with(path).and_return("")
      GameState.should_receive(:new_winner).with({"games"=>{}},winner,id).and_return({})
      GameRecorder.write_winner(id, "x", path)
    end
  end

  describe "integration of GameRecorder and GameState" do

    it "parses all games from the file and updates moves accordingly" do
      game_one = 8
      game_two = 9
      move = {"token" => "x", "position" => 3}
      move_two = {"token" => "o", "position" => 5}
      old_structure = {"games" =>
          {
            game_one =>
          {
            "moves" => [ move ],
            "winner" => nil
          }}}

      expected = {"games" =>
          {
            game_one =>
          {
            "moves" => [ move ],
            "winner" => nil
          },
            game_two =>
          {
            "moves" => [ move_two ]
          }}}
      path = "/me"
      File.stub(:read).with(path).and_return(old_structure.to_json)
      File.should_receive(:write).with(path,JSON.pretty_generate(expected))
      GameRecorder.write_move(game_two,5,"o",path) 
    end
    
    it "parses all games from the file and updates winners accordingly" do
      game = 8
      old_structure = {"games" =>
          {
            game =>
          {
            "winner" => nil
          }}}

      expected = {"games" =>
          {
            game =>
          {
            "winner" => "new winner"
          }}}

      path = "/me"
      File.stub(:read).with(path).and_return(old_structure.to_json)
      File.should_receive(:write).with(path,JSON.pretty_generate(expected))
      GameRecorder.write_winner(game,"new winner",path)
    end
  end
end
