require 'json'
require_relative 'game_state'

class History

  DEFAULT = {"games" => {}}

  def self.retrieve_or_create(path)
    begin
      game_history = JSON.parse(File.read(path)) 
    rescue JSON::ParserError
      game_history = DEFAULT
    end
  end

  def self.write_move(id, move, token, path)
    self.contents_of_file_at(path) do |contents|
      GameState.new_move(contents, token, move, id)
    end
  end

  def self.write_winner(id,winner,path)
    self.contents_of_file_at(path) do |contents|
      GameState.new_winner(contents,winner,id)
    end
  end

  def self.contents_of_file_at(path)
    file_contents = self.retrieve_or_create(path)

    new_contents = yield file_contents

    File.write(path,JSON.pretty_generate(new_contents))
  end
  
end


