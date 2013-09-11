require 'json'

class GameRecorder

  def self.write_to_history(to_write,file=File.open("game_history.json","a"))
    record = Record.new(to_write)
    if record.is_a_move? 
      file.write(JSON.dump("moves" => [to_write]) + "\n")
    elsif  record.is_non_nil_winner?
      file.write(JSON.dump(to_write) + "\n")
    end
    file.close
  end

  
end

class Record

  def initialize(content)
    @content = content
  end

  def is_non_nil_winner?
    !@content.include?("winner") or @content["winner"] != nil
  end

  def is_a_move?
    !@content.include?("winner") and (@content.values.include?("o") or
      @content.values.include?("x"))
  end

end
