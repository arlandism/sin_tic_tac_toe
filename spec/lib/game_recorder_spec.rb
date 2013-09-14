require 'json'
require_relative '../../lib/game_recorder'
require_relative 'mocks'

describe GameRecorder do

  let(:file) { Mock::MockStream.new }

  describe ".write_move" do

    after(:each) do
      file.clear
    end

    it "creates a 'games' data structure if it doesn't exist" do
      id = 1
      move = 3
      token = "x"
      expected = {"games" =>
        {
          id => {
            "moves" =>
              [
                "token" => token,
                "position" => move
              ]
          }}}
      path = "path"
      File.stub(:read).with(path).and_return("")
      GameRecorder.stub(:state_update).and_return(expected)
      File.should_receive(:write).with(path, JSON.pretty_generate(expected))
      GameRecorder.write_move(id, move, token, path)
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
    
    xit "takes an id, winner, and file" do
      id = 2
      winner = "x"
      GameRecorder.write_winner(id, winner, file).should_not == nil
    end

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
      File.should_receive(:write).with(path,expected)
      #file.write(JSON.pretty_generate(old_structure))
      GameRecorder.write_move(game_one,5,"o",file) 
      GameRecorder.write_winner(game_one,"x",file) 
      GameRecorder.write_move(game_two,3,"x",file)
      file.should have_content(JSON.pretty_generate(expected))
    end
  end
end
