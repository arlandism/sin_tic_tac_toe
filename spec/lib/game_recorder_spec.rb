require 'json'
require_relative '../../lib/game_recorder'
require_relative 'mocks'

describe GameRecorder do

  let(:file) { Mock::MockStream.new }

  describe ".compute_file_contents" do

    after(:each) do
      file.clear
    end

    it "creates a 'games' data structure if it doesn't exist at path" do
      expected = {"games" => {}}
      path = "bar" 
      File.stub(:read).with(path).and_return("")
      GameRecorder.compute_file_contents(path).should == expected
    end
    
    it "polls the contents of the file and overwrites existing structure" do
      id = 1
      first_move = {"token" => "x", "position" => 3}
      next_move = {"token" => "o", "position" => 5}
      old_structure = {
        "games" => 
          {
          id =>
          {
            "moves" => [ first_move ],
          }}}

      new_structure = {
        "games" => 
          {
          id =>
          {
            "moves" => [ first_move, next_move ],
          }}}

      path = "foo"
      File.stub(:read).with(path).and_return(old_structure.to_json)
      File.should_receive(:write).with(path, JSON.pretty_generate(new_structure))
      GameRecorder.write_move(id, 5, "o", path)
    end
    
    it "doesn't destroy old data" do
      old_structure = {
        "games" =>
        {
          "2" =>
          {
            "moves" => [{"token" => "x", "position" => 3}]
          },

          "3" =>
          {
            "moves" => [{"token" => "o", "position" => 5}]
          }}}

      new_structure = {
        "games" =>
        {
          "2" =>
          {
            "moves" => [{"token" => "x", "position" => 3}]
          },

          "3" =>
          {
            "moves" => [{"token" => "o", "position" => 5},
                        {"token" => "o", "position" => 4}]
          }}}
      path = "foo"
      File.stub(:read).with(path).and_return(old_structure.to_json)
      File.should_receive(:write).with(path, JSON.pretty_generate(new_structure))

      GameRecorder.write_move(3, 4, "o", path)
    end
  end

  describe ".write_winner" do
    
    it "writes winner to exisitng structure" do
      id = 8
      move = {"token" => "x", "position" => 3}
      old_structure = {"games" =>
          {
            id =>
          {
            "moves" => [ move ]
          }}}

      expected = {"games" =>
          {
          id =>
          {
            "moves" => [ move ],
            "winner" => "x"
          }}}

      path = "??"
      File.stub(:read).with(path).and_return(old_structure.to_json)
      File.should_receive(:write).with(path,JSON.pretty_generate(expected))
      GameRecorder.write_winner(id, "x", path)
    end
  end

  describe "integration of .write_move and .write_winner" do

    xit "parses everything from the file and updates it" do
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
            "moves" => [ move, move_two ],
            "winner" => "x"
          },
            game_two =>
          {
            "moves" => [move]
          }}}
      path = "/me"
      File.stub(:read).with(path).and_return(old_structure.to_json)
      File.should_receive(:write).once.with(path,JSON.pretty_generate(expected))
      GameRecorder.write_move(game_one,5,"o",path) 
      GameRecorder.write_winner(game_one,"x",path) 
      GameRecorder.write_move(game_two,3,"x",path)
    end
  end
end
