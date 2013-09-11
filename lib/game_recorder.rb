require 'json'

class GameRecorder

  def self.write_to_history(to_write,file=File.open("game_history.json","a"))
    record = Record.new(to_write)
    if  record.is_non_nil_winner?
      file.write(JSON.dump(to_write))
    end
    file.close
  end

  def self.write_winner(winner)
  end

  
end

class Record

  def initialize(content)
    @content = content
  end

  def is_non_nil_winner?
    !@content.include?("winner") or @content["winner"] != nil
  end

end
