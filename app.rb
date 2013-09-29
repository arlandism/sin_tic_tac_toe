require 'sinatra'
require 'sinatra/cookies'
require 'sinatra/config_file'
require 'yaml'
require_relative 'lib/db_helpers'

class TTTDuet < Sinatra::Base
  register Sinatra::ConfigFile
  helpers Sinatra::Cookies

  config_file 'config.yml'

end

require_relative 'routes/init'

if __FILE__ == $0 
  DBHelpers.setup_and_login("development")
  TTTDuet.run!
end
