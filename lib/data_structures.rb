
module DataStructures
  def self.presence_fetch(h, key)
    attempt = h.fetch(key, nil)
    if attempt == "" || attempt.nil?
      return yield
    end
    attempt
  end
end
