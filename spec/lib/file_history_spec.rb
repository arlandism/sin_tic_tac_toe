require 'json'
require 'file_history'

describe FileHistory do

  before(:each) do
    File.stub(:write)
  end

  describe ".retrieve_or_create" do

    it "creates a 'games' data structure if it doesn't exist at path" do
      expected = {"games" => {}}
      path = "bar" 
      File.stub(:read).with("bar").and_return("")
      FileHistory.retrieve_or_create(path).should == expected
    end
    
    it "overwrites what used to exist at path" do
      id = "1"
      path = "foo"
      File.stub(:read).with(path).and_return("")
      File.should_receive(:write).with(path, anything)
      FileHistory.write_move(id, 5, "o", path)
    end
    
  end

  describe ".write_winner" do
    
    it "delegates to GameRepository" do
      path = "bar"
      winner = "x"
      id = "3"
      File.should_receive(:read).with(path).and_return("")
      GameTransformer.should_receive(:add_winner).with({"games"=>{}},winner,id).and_return({})
      FileHistory.write_winner(id, "x", path)
    end
  end

  describe ".next_id" do

    it "increments the latest id from history" do
      path = "spec/tmp/test_history.json"
      FileIO.stub(:read).and_return({"games" => 
                                               {"34" => {},
                                                "35" => {}}})
      FileHistory.next_id(path).should == 36
    end
  end

  describe "integration of FileHistory and GameRepository" do

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
      path = "baz"
      File.stub(:read).with(path).and_return(old_structure.to_json)
      File.should_receive(:write).with(path,JSON.pretty_generate(expected))
      FileHistory.write_move(game_two,5,"o",path) 
    end
    
    it "parses all games from the file and updates winners accordingly" do
      game = 8
      old_structure = {"games" => {}}

      expected = {"games" =>
          {
            game =>
          {
            "winner" => "new winner"
          }}}

      path = "baz"
      File.stub(:read).with(path).and_return(old_structure.to_json)
      File.should_receive(:write).with(path,JSON.pretty_generate(expected))
      FileHistory.write_winner(game,"new winner",path)
    end
  end

  describe ".game_by_id" do
    it "returns game with given id" do
      path = "me"
      id = 3
      FileIO.stub(:read).and_return({"games" => {3 => {}}})
      FileHistory.game_by_id(path,id).should == {}
    end
  end
end
