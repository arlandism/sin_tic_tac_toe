require 'models/game'

class DatabaseIO

  def self.read(path)
    DataMapper.setup(:default, path)
    games = Game.all
    games unless empty?(games)
  end

  private

  def self.empty?(game_storage)
    game_storage == []
  end

end
