module Mock

  class MockStream 

    attr_reader :close_called
    attr_reader :read_called
    attr_reader :history

    def initialize
      @history = Array.new
      @close_called = false
      @read_called = false
    end

    def read
      @read_called = true
      @history.pop || ""
    end

    def write(to_write)
      @history << to_write
    end

    def close
      @close_called = true
    end

    def clear
      @history.clear
    end

    def has_content?(content)
      @history.include?(content)
    end

  end

end
