module DBHelpers

  def self.setup_and_login(env, auto_migrate=false)
  config = YAML.load_file("database.yaml")[env]
  db_type = config["adapter"]
  user = config["user"] 
  pass = config["password"]
  host = config["host"]
  db = config["database"]
  db_path = "#{db_type}://#{user}:#{pass}@#{host}/#{db}"
  DataMapper.setup(:default, db_path)
  DataMapper.finalize
  if auto_migrate
    DataMapper.auto_migrate!
  else
    DataMapper.auto_upgrade!
  end
  end
end
