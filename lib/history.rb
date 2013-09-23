require 'json'
require_relative 'game_repository'
require_relative 'file_history_reader'
require_relative 'file_history_writer'

class History

  def self.retrieve_or_create(path, reader=FileHistoryReader,
                              exception=JSON::ParserError)
    begin
      game_history = reader.read(path) 
    rescue exception
      game_history = {"games" => {}}
    end
  end

  def self.write_move(id, move, token, path,
                      writer=FileHistoryWriter)
    self.open_and_write_to(path, writer) do |contents|
      GameRepository.add_move(contents, token, move, id)
    end
  end

  def self.write_winner(id,winner,path,
                        writer=FileHistoryWriter)
    self.open_and_write_to(path, writer) do |contents|
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

  def self.open_and_write_to(path,writer)
    file_contents = self.retrieve_or_create(path)

    new_contents = yield file_contents

    writer.write(path, new_contents)
  end
  
end


