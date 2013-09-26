require 'data_mapper'

class Move
  include DataMapper::Resource

  property :id, Serial, :key => true
  property :position, Integer
  property :token, String

  belongs_to :game

end
