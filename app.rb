require 'sinatra'
require 'sinatra/cookies'
require 'sinatra/config_file'

class TTTDuet < Sinatra::Base
  register Sinatra::ConfigFile
  helpers Sinatra::Cookies

  config_file 'config.yml'

end

require_relative 'routes/init'

if __FILE__ == $0 
  TTTDuet.run!
end
