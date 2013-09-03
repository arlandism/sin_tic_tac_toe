require_relative '../lib/cpu_move'

describe CpuMove do

  describe "#should_place" do

    it "knows to return true when first player set to computer and no moves have been made" do
      game_description = {"first_player" => "computer"}

      CpuMove.should_receive(:moves_made).with(game_description).and_return(false)

      CpuMove.should_place(game_description).should == true
    end

    it "knows to return false when first player isn't computer" do
      CpuMove.should_place({"first_player" => "non-computer"}).should == false
    end

    it "knows to return false when moves_made returns true" do
      CpuMove.stub(:moves_made).and_return(true)

      CpuMove.should_place({"first_player" => "computer"}).should == false
    end
  end

  describe "#moves_made" do

    it "returns false with a hash with no 'x' or 'o' values" do
      CpuMove.moves_made({"animal" => "dog"}).should == false
    end

    it "returns true with a hash with an 'x' in the values" do
      CpuMove.moves_made({"letter" => "x"}).should == true
    end

    it "returns true with a hash with an 'o' in the values" do
      CpuMove.moves_made({"letter" => "o"}).should == true
    end
  end
end
