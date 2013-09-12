require 'json'
require_relative '../../lib/game_recorder'
require_relative 'mocks'

describe GameRecorder do

  describe ".write_move" do

    let(:file) { Mock::MockStream.new }

    after(:each) do
      file.clear
    end

    it "writes moves to files in json" do
      id = 1
      move = 3
      token = "x"
      expected = {"games" =>
        {
          1 => {
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
  end

  describe ".write_winner" do
    
    it "takes an id and an winner" do
      id = 2
      winner = "x"
      GameRecorder.write_winner(id, winner).should_not == nil
    end

    xit "writes winner to exisitng structure" do
      id = 8
      expected = {
        id =>
        {
          "winner" => [ first_move ],
        }}

        new_structure = {
          id =>
        {
          "moves" => [ first_move, next_move]
        }}

      file.write(JSON.dump(old_structure))
      GameRecorder.write_move(id, 5, "o", file)
      file.read_called.should == true
      file.should have_content(JSON.dump(new_structure))
    end
  end
end

# {"game_id - 123" =>
#  "moves" => {
#    "x" => [1,2,3],
#    "o" => [4,5,6]
#  }
#  "winner" => "x"
# }
