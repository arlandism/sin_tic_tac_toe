class FileIO

  def self.read(path)
    begin
      JSON.parse(File.read(path))
    rescue JSON::ParserError
      raise NoContentError
    end
  end

  def self.write(path, contents)
    File.write(path, JSON.pretty_generate(contents))
  end

  def self.open_and_write_to(path)
    file_contents = self.retrieve_or_create(path)

    new_contents = yield file_contents

    writer.write(path, new_contents)
  end
end

class NoContentError < Exception
end
