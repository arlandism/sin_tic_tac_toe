require 'db_helper'
require 'database_io'

describe DatabaseIO do

  let (:path)       { "/baz" }
  let (:game_model) { Game }

  before(:each) do
    TestDBMethods.login_to_test_db
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

    it "creates the game if it doesn't exist" do
      DatabaseIO.write_move(path, id, position, token) 
      move = Move.get(id)
      move.game.id.should == id
    end
  end

  describe ".write_winner" do

    let (:id) { 4 }
  
    it "creates a winner column in the game with the same id" do
      Game.create(:id => id)
      DatabaseIO.write_winner(id, "x", path)
      game = Game.get(id)
      game.winner.should == "x"
    end

    it "creates the game if it doesn't exist" do
      DatabaseIO.write_winner(4, "o", path)
      Game.get(id).winner.should == "o"
    end
  end
end