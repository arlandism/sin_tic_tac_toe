require 'data_mapper'

require_relative '../../lib/database_io'

config = YAML.load_file("database.yaml")["test"]
db_type = config["adapter"]
user = config["user"] 
pass = config["password"]
host = config["host"]
db = config["database"]

describe DatabaseIO do

  let (:path) { "/baz" }
  let (:game_model) { Game }

  before(:each) do
    test_db_path ="#{db_type}://#{user}:#{pass}@#{host}/#{db}"
    DataMapper.setup(:default, test_db_path)
    DataMapper.finalize
    DataMapper.auto_migrate!
  end

  describe ".read" do
    

    before(:each) do
      DataMapper.should_receive(:setup).with(:default, path)
      Game.stub(:get)
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
  
    let (:id)       { 3 }
    let (:position) { 4 }
    let (:token)    { "x" }
    
    it "creates a move record in the game with same id" do
      game = Game.create(:id => id)
      DatabaseIO.write_move(path, id, position, token) 
      game.moves.first.position.should == 4
      game.moves.first.token.should == "x"
    end
  end
  
end
