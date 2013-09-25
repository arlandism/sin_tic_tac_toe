require_relative '../../lib/game_repository'

describe GameRepository do

  describe ".new_move" do
    
    it "creates a new game if it doesn't exist" do
      id = "1"
      move = 3
      token = "x"
      expected = {"games" =>
        {
          id => {
            "moves" =>
              [
                "token" => token,
                "position" => move
              ]
          }}}
      GameRepository.add_move({"games" => {}}, token, move, id).should == expected
    end

    it "polls the data structure it gets and returns it with updated moves" do
      id = "1"
      first_move = {"token" => "x", "position" => 3}
      next_move = {"token" => "o", "position" => 5}
      old_structure = {
        "games" => 
          {
          id =>
          {
            "moves" => [ first_move ],
          }}}

      new_structure = {
        "games" => 
          {
          id =>
          {
            "moves" => [ first_move, next_move ],
          }}}
      GameRepository.add_move(old_structure, "o", 5, id).should == new_structure
    end

    it "doesn't add moves with positions of 0" do
      id = "2"
      position = 0
      expected_structure = {"games" => {id => {"moves" => []}}}
      GameRepository.add_move({"games" => {}},"x",position,id).should == expected_structure
    end
  end

  describe ".write_winner" do
    it "creates a new winner if it doesn't exist" do
      id = "8"
      move = {"token" => "x", "position" => 3}
      old_structure = {"games" =>
          {
            id =>
          {
            "moves" => [ move ]
          }}}

      expected = {"games" =>
          {
          id =>
          {
            "moves" => [ move ],
            "winner" => "x"
          }}}
      GameRepository.add_winner(old_structure, "x", id).should == expected
    end
    
    it "overwrites the previous winner" do
      id = "8"
      move = {"token" => "x", "position" => 3}
      old_structure = {"games" =>
          {
            id =>
          {
            "winner" => "HAHA I won!"
          }}}

      expected = {"games" =>
          {
          id =>
          {
            "winner" => "Not anymore!"
          }}}
      GameRepository.add_winner(old_structure, "Not anymore!", id).should == expected
    end
  end

  describe ".game_by_id" do
    
    it "returns the game with given id" do
      id = "8"
      games = {"games" => {id => {}}}

      GameRepository.game_by_id(games, id).should == {}
    end

    it "adds a skeleton structure if it can't find the game" do
      id = "not a real id"
      games = {"games" => {}}

      GameRepository.game_by_id(games, id).should == {"moves" => [], "winner" => nil}
    end
  end
end
