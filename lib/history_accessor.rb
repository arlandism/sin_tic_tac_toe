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
