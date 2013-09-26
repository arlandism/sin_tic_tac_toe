require 'data_mapper'

class Move
  include DataMapper::Resource

  property :position, Integer
  property :token, String

  belongs_to :game, :key => true

end
