require_relative '../../lib/models/game'

describe Game do

  describe ".next_id" do
    it "returns the next available id (highest current id + 1) from the database" do
      Game.create(:id => 1)
      Game.create(:id => 2)
      Game.next_id.should == 3 
      Game.get(1).destroy
      Game.get(2).destroy
    end

    it "returns 1 if nothing is stored" do
      Game.next_id.should == 1
    end
  end
end
