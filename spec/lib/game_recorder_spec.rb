require 'json'
require_relative '../../lib/game_recorder'
require_relative 'mocks'

describe GameRecorder do

  let(:file) { Mock::MockStream.new }

  describe ".write_move" do

    after(:each) do
      file.clear
    end

    it "creates a 'games' data structure" do
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
          }
        }
      }
      GameRecorder.write_move(id,move,token,file)
      file.should have_content(JSON.dump(expected))
      file.close_called.should == true
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
            "games" => {
              id =>
            {
              "moves" => [ first_move, next_move]
            }
          }}

      file.write(JSON.dump(old_structure))
      GameRecorder.write_move(id, 5, "o", file)
      file.read_called.should == true
      file.should have_content(JSON.dump(new_structure))
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
          }
      }}
      file.write(JSON.dump(old_structure))
      GameRecorder.write_move(3, 4, "o", file)
      old_structure["games"]["3"]["moves"] << {"token" => "o", "position" => 4}
      file.should have_content(JSON.dump(old_structure))
    end
  end

  describe ".write_winner" do
    
    it "takes an id, winner, and file" do
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
          }
        }
      }

      expected = {"games" =>
          {
          id =>
          {
            "moves" => [ move ],
            "winner" => "x"
          }
        }
      }

      file.write(JSON.dump(old_structure))
      GameRecorder.write_winner(id, "x", file)
      file.read_called.should == true
      file.should have_content(JSON.dump(expected))
    end
  end
end
