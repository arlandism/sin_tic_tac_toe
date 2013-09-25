require 'data_mapper'

require_relative '../../lib/database_io'

describe DatabaseIO do

  describe ".read" do
    
    let (:path) { "/baz" }
    let (:game_model) { Game }

    before(:each) do
      DataMapper.should_receive(:setup).with(:default, path)
    end

    it "delegates to Game.all" do
      game_model.should_receive(:all)
      DatabaseIO.read(path)
    end

    it "returns nil if Game.all returns []" do
      game_model.stub(:all).and_return([])
      DatabaseIO.read(path).should == nil
    end

    it "returns what Game.all gave us otherwise" do
      game_model.stub(:all).and_return([2, 3, 4])
      DatabaseIO.read(path).should == [2, 3, 4]
    end
  end

  describe ".write_move" do
  
    it "delegates to Game.create" do
      game_data = {
        
      }
    end
  end

  
end
