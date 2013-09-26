require 'database_io'
require 'database_interpreter'

class DBHistory

  def self.retrieve_or_create(path)
    DatabaseIO.read(path) || {"games" => {}}
  end

  def self.write_move(id, move, token, path)
    DatabaseIO.write_move(path, id, move, token)
  end

  def self.write_winner(id, winner, path)
    DatabaseIO.write_winner(path, id, winner)
  end

  def self.game_by_id(path, id)
    game = DatabaseIO.game_by_id(id)
    DBInterpreter.translate_game(game)
  end

end
