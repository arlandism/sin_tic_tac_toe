require 'cucumber/rspec/doubles'
require 'capybara'
require 'capybara/cucumber'
require 'rspec'
require File.join(File.dirname(__FILE__), '..', '..', 'app.rb')

ENV['RACK_ENV'] = 'test'

Capybara.app = TTTDuet

`python /Users/arlandislawrence/development/python/tic_tac_toe/network_io/start_server.py &>log.txt &`

class MyAppWorld
  include Capybara::DSL
  include RSpec::Expectations
  include RSpec::Matchers
end

World do
  MyAppWorld.new
end
