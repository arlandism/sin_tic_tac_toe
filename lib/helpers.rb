class Helpers

  def self.hash_with_keys_as_ints(hash)
    new_hash = Hash.new
    hash.each do |key, value|
      new_hash[key.to_i] = value
    end
    new_hash
  end

  def self.add_hashes(hash_one,hash_two)
    hash_with_keys_as_ints(hash_one.merge(hash_two))
  end

  def self.winner(hash)
    hash["winner"]
  end

  def self.call_ai(ai,hash)
    ai.next_move(hash) 
  end

  def self.ai_move(hash)
    hash["move"]
  end
end
