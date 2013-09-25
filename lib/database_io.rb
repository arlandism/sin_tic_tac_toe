require 'models/game'
require 'models/move'

class DatabaseIO

  def self.read(path)
    DataMapper.setup(:default, path)
    games = Game.all
    games unless empty?(games)
  end

  def self.write_move(path, id, position, token)
    Move.create(
      :id => id,
      :position => position,
      :token => token
    )

    Game.get(id)
  end

  private

  def self.empty?(game_storage)
    game_storage == []
  end

end
