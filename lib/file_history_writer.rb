require 'json'

class FileHistoryWriter

  def self.write(path, contents)
    File.write(path,JSON.pretty_generate(contents))
  end

end
