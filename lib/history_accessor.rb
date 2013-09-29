require 'yaml'
require_relative 'file_history'
require_relative 'db_history'

class HistoryAccessor

  def self.retrieve_or_create(path_for_file_history, config_path)
    history_accessor(config_path).retrieve_or_create(path_for_file_history)
  end

  def self.write_move(id, move, token, path, config_path)
    history_accessor(config_path).write_move(id, move, token, path)
  end

  def self.write_winner(id, winner, path, config_path)
    history_accessor(config_path).write_winner(id, winner, path)
  end

  def self.next_id(path, config_path)
    history_accessor(config_path).next_id(path)
  end

  def self.game_by_id(path, id, config_path)
    history_accessor(config_path).game_by_id(path, id)
  end

  private

  def self.history_accessor(config_path)
    Object.const_get("#{YAML.load_file(config_path)["history_accessor"]}")
  end

end
