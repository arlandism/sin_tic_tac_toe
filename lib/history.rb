require 'json'
require_relative 'game_repository'

class History

  def self.retrieve_or_create(path)
    begin
      game_history = JSON.parse(File.read(path)) 
    rescue JSON::ParserError
      game_history = {"games" => {}}
    end
  end

  def self.write_move(id, move, token, path)
    self.open_and_write_to(path) do |contents|
      GameRepository.add_move(contents, token, move, id)
    end
  end

  def self.write_winner(id,winner,path)
    self.open_and_write_to(path) do |contents|
      GameRepository.add_winner(contents,winner,id)
    end
  end

  def self.next_id(path)
    games = self.retrieve_or_create(path)
    ids = games["games"].keys
    ids.sort
    highest_id = ids[-1].to_i
    next_id = highest_id + 1
    next_id.to_s
  end

  private

  def self.open_and_write_to(path)
    file_contents = self.retrieve_or_create(path)

    new_contents = yield file_contents

    File.write(path,JSON.pretty_generate(new_contents))
  end
  
end


