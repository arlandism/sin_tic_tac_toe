require 'data_mapper'
require 'yaml'

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
  
    it "creates a move record" do
      id = 3
      position = 4
      token = "x"

      DatabaseIO.write_move(path, id, position, token) 
      Move.get(id).position.should == position
      Move.get(id).token.should == token
    end

    it "retrieves game with given i.d." do
      id = 3
      game_model.should_receive(:get).with(3)
      DatabaseIO.write_move(path, id, 3, "x")
    end
  end

  
end
