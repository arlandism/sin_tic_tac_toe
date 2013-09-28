require 'yaml'
require_relative 'file_history'

class HistoryAccessor

  def self.retrieve_or_create(path_for_file_history, config_path)
    history_accessor = YAML.load_file(config_path)["history_accessor"]
    AccessorFactory.create(history_accessor).retrieve_or_create(path_for_file_history)
  end

  def self.write_move(id, move, token, path, config_path)
    history_accessor = YAML.load_file(config_path)["history_accessor"]
    AccessorFactory.create(history_accessor).write_move(id, move, token, path)
  end

  def self.write_winner(id, winner, path, config_path)
    history_accessor = YAML.load_file(config_path)["history_accessor"]
    AccessorFactory.create(history_accessor).write_winner(id, winner, path)
  end

  def self.next_id(path, config_path)
    history_accessor = YAML.load_file(config_path)["history_accessor"]
    AccessorFactory.create(history_accessor).next_id(path)
  end

  def self.game_by_id(path, id, config_path)
    history_accessor = YAML.load_file(config_path)["history_accessor"]
    AccessorFactory.create(history_accessor).game_by_id(path, id)
  end

end

class AccessorFactory

  def self.create(name)
    if name == "FileHistory"
      FileHistory
    elsif name == "DBHistory"
      DBHistory
    end
  end

end
