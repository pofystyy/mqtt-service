module Mqtt
  class ConfigValidator
    class BaseException < RuntimeError; end
    class MissingConfigException < BaseException; end

    def self.check(data)
      (data.nil? || data.class != String) ? raise(MissingConfigException) : data
    end
  end
end
