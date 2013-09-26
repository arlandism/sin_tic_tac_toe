require 'data_mapper'

class Game
  include DataMapper::Resource

  property :id, Serial
  property :winner, String

  has n, :moves

end
