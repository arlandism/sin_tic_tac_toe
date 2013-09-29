require 'sinatra'
require 'sinatra/cookies'
require 'sinatra/config_file'
require 'yaml'

class TTTDuet < Sinatra::Base
  register Sinatra::ConfigFile
  helpers Sinatra::Cookies

  config_file 'config.yml'

end

require_relative 'routes/init'

if __FILE__ == $0 
  db_config = YAML.load_file("database.yaml")["development"]
  DataMapper.setup(:default, "#{db_config["adapter"]}://#{db_config["user"]}: #{db_config["password"]} @#{db_config["host"]}/#{db_config["database"]}")
  DataMapper.finalize
  DataMapper.auto_migrate!
  TTTDuet.run!
end
