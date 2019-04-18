module Mqtt
  class Config
    attr_accessor :config_name

    def initialize(config_name)
      @config_name = config_name
    end

    def file
      @file ||= File.dirname(File.expand_path(__FILE__)) + "/config/#{config_name}.yml"
    end

    def attributes
      @attributes ||= YAML.load(ERB.new(File.read(file)).result)
    end

    def config
      attributes
    end
  end
end
