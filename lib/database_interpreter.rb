class DBInterpreter

  def self.translate_games(games)
    games.inject({"games" => {}}) do |acc, game|
      acc["games"][game.id] = translate_game(game)
      acc
    end if games != nil
  end

  def self.translate_game(game)
    {
      "moves" => game.moves.map { |move| attr_keys_to_str(move) },
      "winner" => game.winner
    }
  end

  private

  def self.hash_keys_to_str(hash)
    hash.inject({}) do |h, (key, val)|
      h[key.to_s] = val
      h
    end
  end

  def self.attr_keys_to_str(model)
    hash_keys_to_str(model.attributes)
  end

end
