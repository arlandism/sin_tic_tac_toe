require 'rack/test'

require_relative 'spec_utils'
require_relative '../../app'

before(:each) do 
  History.stub(:write_move)
  History.stub(:write_winner)
end

def app
  TTTDuet.new
end
