require_relative 'database_io'
require_relative  'database_interpreter'

class DBHistory

  def self.retrieve_or_create(path)
    DBInterpreter.translate_games(DatabaseIO.read(path)) || {"games" => {}}
  end

  def self.write_move(id, move, token, path)
    DatabaseIO.write_move(path, id, move, token)
  end

  def self.write_winner(id, winner, path)
    DatabaseIO.write_winner(path, id, winner)
  end

  def self.next_id(path)
    DatabaseIO.next_id
  end

  def self.game_by_id(path, id)
    game = DatabaseIO.game_by_id(id)
    DBInterpreter.translate_game(game)
  end

end
