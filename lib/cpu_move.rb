class CpuMove

  def self.should_place(game_description)
    game_description["first_player"] == "computer" and CpuMove.moves_made(game_description) == false
  end

  def self.moves_made(game_description)
    game_description.values.select { |val|  val.eql?("x") or val.eql?("o") }.length != 0
  end

end
