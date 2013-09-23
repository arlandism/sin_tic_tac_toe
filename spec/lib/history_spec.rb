require 'json'
require_relative '../../lib/history'

describe History do

  before(:each) do
    File.stub(:write)
  end

  describe ".retrieve_or_create" do

    it "creates a 'games' data structure if it doesn't exist at path" do
      expected = {"games" => {}}
      path = "bar" 
      File.stub(:read).with("bar").and_return("")
      History.retrieve_or_create(path).should == expected
    end
    
    it "overwrites what used to exist at path" do
      id = "1"
      path = "foo"
      File.stub(:read).with(path).and_return("")
      File.should_receive(:write).with(path, anything)
      History.write_move(id, 5, "o", path)
    end
    
  end

  describe ".write_winner" do
    
    it "delegates to GameRepository" do
      path = "bar"
      winner = "x"
      id = "3"
      File.should_receive(:read).with(path).and_return("")
      GameRepository.should_receive(:add_winner).with({"games"=>{}},winner,id).and_return({})
      History.write_winner(id, "x", path)
    end
  end

  describe ".next_id" do

    it "increments the latest id from history" do
      path = "spec/tmp/test_history.json"
      FileHistoryReader.stub(:read).and_return({"games" => 
                                               {"34" => {},
                                                "35" => {}}})
      History.next_id(path).should == 36
    end
  end

  describe "integration of History and GameRepository" do

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
      History.write_move(game_two,5,"o",path) 
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
      History.write_winner(game,"new winner",path)
    end
  end
end
