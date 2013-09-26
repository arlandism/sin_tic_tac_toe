require 'models/game'
require 'models/move'

class DatabaseIO

  def self.read(path)
    DataMapper.setup(:default, path)
    games = Game.all
    games unless empty?(games)
  end

  def self.write_move(path, id, position, token)
    if game_exists?(id)
      create_move(id, position, token)
    else
      create_game(id)
      create_move(id, position, token)
    end
  end

  def self.write_winner(id, winner, path)
    if game_exists?(id)
      update_winner(id, winner)
    else
      create_game(id)
      update_winner(id, winner)
    end
  end

  private

  def self.create_game(id)
    Game.create(:id => id)
  end

  def self.create_move(id, position, token)
    Move.create(
      :id => id,
      :position => position,
      :token => token,
      :game_id => id
    )
  end

  def self.update_winner(id, winner)
    Game.get(id).update(:winner => winner)
  end

  def self.game_exists?(id)
    Game.get(id)
  end

  def self.empty?(game_storage)
    game_storage == []
  end

end

