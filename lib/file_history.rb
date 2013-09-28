require 'json'
require_relative 'game_transformer'
require_relative 'file_io'

class FileHistory

  def self.retrieve_or_create(path)
    FileIO.read(path) || {"games" => {}}
  end

  def self.write_move(id, move, token, path)
    self.open_and_write_to(path) do |contents|
      GameTransformer.add_move(contents, token, move, id)
    end
  end

  def self.write_winner(id,winner,path)
    self.open_and_write_to(path) do |contents|
      GameTransformer.add_winner(contents,winner,id)
    end
  end

  def self.next_id(path)
    games = self.retrieve_or_create(path)
    games["games"].keys.max.to_i + 1
  end

  def self.game_by_id(path, id)
    GameTransformer.game_by_id(FileIO.read(path), id)
  end

  private

  def self.open_and_write_to(path)
    file_contents = self.retrieve_or_create(path)

    new_contents = yield file_contents

    FileIO.write(path, new_contents)
  end
  
end


