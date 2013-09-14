require 'json'
require_relative 'game_state'

class GameRecorder

  DEFAULT = {"games" => {}}

  def self.compute_file_contents(path)
    begin
      file_contents = JSON.parse(File.read(path)) 
    rescue JSON::ParserError
      file_contents = DEFAULT
    end
  end

  def self.write_move(id, move, token, path="game_history.json")
    self.contents_of_file_at(path) do |contents|
      GameState.new_move(contents, token, move, id)
    end
  end

  def self.write_winner(id,winner,path="game_history.json")
    self.contents_of_file_at(path) do |contents|
      GameState.new_winner(contents,winner,id)
    end
  end

  def self.contents_of_file_at(path)
    file_contents = self.compute_file_contents(path)

    new_contents = yield file_contents

    File.write(path,JSON.pretty_generate(new_contents))
  end
  
end


