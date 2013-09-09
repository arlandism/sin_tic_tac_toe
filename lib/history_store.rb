require_relative 'game_record'

class HistoryStore

  @@id = 0
  @@games = Hash.new

  def self.new_game
    @@id += 1
    game = GameRecord.new(@@id)
    @@games[@@id] = game
  end

  def self.record_move(id,move,token)
    game_record = @@games[@@id] 
    game_record.set_move(move,token)
  end

  def self.game_by_id(id)
    @@games[id]
  end

end
