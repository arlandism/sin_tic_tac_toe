class DBInterpreter

  def self.translate_game(game)
    {
      "moves" => 
      [
        hash_keys_to_str(game.moves.first.attributes)
      ],
      "winner" => game.winner
    }
  end

  def self.hash_keys_to_str(hash)
    hash.inject({}) do |h, (key, val)|
      h[key.to_s] = val
      h
    end
  end

end
