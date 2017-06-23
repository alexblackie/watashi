module Watashi
  # A centralized way to get configuration options. Reads values out of
  # `config.yml` (or whatever name is passed to `populate`).
  class Config

    CONFIG_PATH = File.join(File.dirname(__FILE__), "..", "..", "config")

    # Loads the config into memory from disk. Called automatically on the first
    # cold-get, but can be called manually to warm up.
    #
    # @param name [String] the name of the confg file to load. If not provided, will use the value of WATASHI_ENV.
    def self.populate(name = nil)
      name ||= ENV["WATASHI_ENV"]
      @@config = YAML.load_file(File.join(CONFIG_PATH, "#{name}.yml"))
    end

    # Get the value of a config option
    #
    # @param key [String] the key to fetch
    # @return [any] whatever key contains
    def self.get(key)
      populate unless class_variable_defined?(:@@config)
      @@config[key]
    end

  end
end
