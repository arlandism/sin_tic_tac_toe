require 'json'
require_relative '../../lib/game_recorder'
require_relative 'mocks'

describe GameRecorder do

  describe ".write_to_history" do
    let(:file) { Mock::MockStream.new }

    it "writes to a specified stream in json and closes it" do
      greeting = {"greeting" => "hello"}
      GameRecorder.write_to_history(greeting,file)
      file.should have_content(JSON.dump(greeting) + "\n")
      file.close_called.should == true
    end

    it "doesn't write hashes with nil values in winner key" do
      winner = {"winner" => nil}
      GameRecorder.write_to_history(winner,file)
      file.should_not have_content(JSON.dump(winner) + "\n")
    end

    it "writes hashes with non-nil values in winner key" do
      winner = {"winner" => "x"}
      GameRecorder.write_to_history(winner,file)
      file.should have_content(JSON.dump(winner) + "\n")
    end 

    it "puts moves in a moves array in the json file" do
      move_one = {1 => "x"}
      GameRecorder.write_to_history(move_one,file)
      expected = {
        "moves" => [move_one]
      }
      file.should have_content(JSON.dump(expected) + "\n")
    end

    it "appends moves to the exisitng moves data structure" do
      GameRecorder.write_to_history({1 => "x"},file)
      expected = {
        "moves" => {"x" => [1], "o" => [3]}
      }
      GameRecorder.write_to_history({3 => "o"},file) 
      file.should have_content(JSON.dump(expected))
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
