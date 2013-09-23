class FileIO

  def self.read(path)
    JSON.parse(File.read(path))
  end

  def self.write(path, contents)
    File.write(path, JSON.pretty_generate(contents))
  end

end
