require_relative 'models/game'
require_relative 'models/move'

class DatabaseIO

  def self.read(path)
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

  def self.next_id
    Game.next_id
  end

  def self.game_by_id(id)
    Game.get(id)
  end

  private

  def self.not_nil(position)
     position != 0 
  end

  def self.create_game(id)
    Game.create(:id => id)
  end

  def self.create_move(id, position, token)
    Move.create(
      :position => position,
      :token => token,
      :game_id => id
    ) if not_nil(position)
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

