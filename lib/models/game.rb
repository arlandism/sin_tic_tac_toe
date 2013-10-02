require 'data_mapper'

class Game
  include DataMapper::Resource

  property :id, Serial
  property :winner, String

  has n, :moves

  def self.next_id
    prev_id = last_id || 0
    prev_id + 1
  end

  private

  def self.last_id
    last.id if last
  end

end
