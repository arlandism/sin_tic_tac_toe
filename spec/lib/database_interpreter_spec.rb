require 'db_helper'

require_relative '../../lib/models/game'
require_relative '../../lib/database_interpreter'

describe DBInterpreter do

  before(:each) do
    TestDBMethods.login_to_test_db
  end

  def make_move(id, pos, token)
    Move.create(
      :game_id => id,
      :position => pos,
      :token => token
    )
  end

  def translated_move(id,game_id, pos, token)
    {
     "position" => pos,
     "token" => token,
     "game_id" => game_id,
     "id" => id
    }
  end

  def create_test_game_and_moves
    game = Game.create(:id => 3, :winner => nil)
    make_move(3,3,"o")
    make_move(3,4,"x")
    game
  end

  def translated_game(winner, *moves)
    {
      "moves" => moves,
      "winner" => winner
    }
  end

  let(:move)     { translated_move(1, 3, 3, "o") }
  let(:move_two) { translated_move(2, 3, 4, "x") } 

  describe ".translate_game" do

    it "takes a database format of the game and reformats it" do
      game = create_test_game_and_moves
      DBInterpreter.translate_game(game).should == 
        translated_game(nil, move, move_two)
    end
  end

  describe ".translate_games" do
    
    it "takes a database format of all the games and reformats it" do
      create_test_game_and_moves
      new_move = translated_move(3,4,4,"x")
      Game.create(:id => 4, :winner => nil)
      make_move(4,4,"x")
      expected = {
        "games" => {
          3 => translated_game(nil, move, move_two),
          4 => translated_game(nil, new_move)
      }}
      DBInterpreter.translate_games(Game.all).should == expected
    end
  end
end
