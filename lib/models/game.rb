require 'data_mapper'

class Game
  include DataMapper::Resource

  property :id, Serial

  has n, :moves

end
