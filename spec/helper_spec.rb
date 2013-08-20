require_relative '../lib/helpers'

describe "Helpers" do

  describe "#winner" do
    context "o is the winner"
    it "pulls winner out of a hash" do
      Helpers.winner({"winner" => "o"}).should == "o"
    end

    context "x is the winner"
    it "pulls winner out of a hash" do
      Helpers.winner({"winner" => "x"}).should == "x"
    end

    context "winner is nil"
    it "pulls winner out of hash" do
      Helpers.winner({"winner" => nil}).should == nil
    end
  end
end
