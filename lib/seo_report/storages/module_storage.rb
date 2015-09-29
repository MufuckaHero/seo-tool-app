require 'yaml'

module Storage
  class DbSqlStorage
    class << self; attr_accessor :config_path; end

    @config_path = YAML.load_file("config/initializers/db_config.yml")
  end
end