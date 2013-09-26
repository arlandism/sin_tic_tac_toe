require 'db_helper'

require_relative '../../lib/models/game'
require_relative '../../lib/database_interpreter'

describe DBInterpreter do

  before(:each) do
    TestDBMethods.login_to_test_db
  end

  def create_test_game_and_moves
    game = Game.create(:id => 3, :winner => nil)
    Move.create(
      :game_id => 3,
      :position => 3,
      :token => "o"
    )
    Move.create(
      :game_id => 3,
      :position => 4,
      :token => "x"
    )
    game
  end

  let(:move)     { {"position" => 3, 
                    "token" => "o",
                    "game_id" => 3,
                    "id" => 1} }

  let(:move_two) { {"position" => 4, 
                    "token" => "x",
                    "game_id" => 3,
                    "id" => 2} }

  describe ".translate_game" do

    it "takes a database format of the game and reformats it" do
      game = create_test_game_and_moves
      expected = {
        "moves" => [move, move_two],
        "winner" => nil
      }
      DBInterpreter.translate_game(game).should == expected
    end
  end

  describe ".translate_games" do
    
    it "takes a database format of all the games and reformats it" do
      create_test_game_and_moves
      new_move = {
        "position" => 4,
        "token" => "x",
        "game_id" => 4,
        "id" => 3
      }
      Game.create(:id => 4, :winner => nil)
      Move.create(
        :game_id => 4,
        :position => 4,
        :token => "x"
      )
      expected = {
        "games" => {
          3 => {
          "moves" => [move, move_two],
          "winner" => nil
          },
         4 => {
           "moves" => [new_move],
           "winner" => nil}}}
      DBInterpreter.translate_games(Game.all).should == expected
    end
  end
end
