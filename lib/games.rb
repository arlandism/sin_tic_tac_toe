
class Games

  def self.retrieve_or_create(path)
    DatabaseIO.read(path) || {"games" => {}}
  end

  def self.write_move(id, move, token, path)
    DatabaseIO.write_move(path, id, move, token)
  end

  def self.write_winner(id, winner, path)
    DatabaseIO.write_winner(path, id, winner)
  end

end

class DatabaseIO

  def self.read(path)
  end

end
