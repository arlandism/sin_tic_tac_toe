require 'yaml'
require 'data_mapper'

module TestDBMethods

  def self.login_to_test_db
    config = YAML.load_file("database.yaml")["test"]
    db_type = config["adapter"]
    user = config["user"] 
    pass = config["password"]
    host = config["host"]
    db = config["database"]
    test_db_path = "#{db_type}://#{user}:#{pass}@#{host}/#{db}"
    datamapper_setup!(test_db_path)
  end

  private

  def self.datamapper_setup!(test_db_path)
    DataMapper.setup(:default, test_db_path)
    DataMapper.finalize
    DataMapper.auto_migrate!
  end

end
