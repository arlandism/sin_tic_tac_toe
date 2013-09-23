require 'json'

class FileHistoryReader

  def self.read(path)
    JSON.parse(File.read(path))
  end

end
