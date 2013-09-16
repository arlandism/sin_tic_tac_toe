require_relative '../../lib/game_state'

describe GameState do

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
      GameState.new_move({"games" => {}}, token, move, id).should == expected
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
      GameState.new_move(old_structure, "o", 5, id).should == new_structure
    end

    it "doesn't add moves with positions of 0" do
      id = "2"
      position = 0
      expected_structure = {"games" => {id => {"moves" => []}}}
      GameState.new_move({"games" => {}},"x",position,id).should == expected_structure
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
      GameState.new_winner(old_structure, "x", id)
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
      GameState.new_winner(old_structure, "Not anymore!", id).should == expected
    end
  end
end
