require 'data_mapper'

class Move
  include DataMapper::Resource

  property :id, Integer, :key => true
  property :position, Integer
  property :token, String
  
end
