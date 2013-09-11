require 'json'
require_relative '../../lib/game_recorder'
require_relative 'mocks'

describe GameRecorder do

  describe ".write_to_history" do
    let(:file) { Mock::MockStream.new }

    it "writes to a specified stream in json and closes it" do
      greeting = {"greeting" => "hello"}
      GameRecorder.write_to_history(greeting,file)
      file.should have_content(JSON.dump(greeting))
      file.close_called.should == true
    end

    it "doesn't write hashes with nil values in winner key" do
      winner = {"winner" => nil}
      GameRecorder.write_to_history(winner,file)
      file.should_not have_content(JSON.dump(winner))
    end

    it "writes hashes with non-nil values in winner key" do
      winner = {"winner" => "x"}
      GameRecorder.write_to_history(winner,file)
      file.should have_content(JSON.dump(winner))
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
