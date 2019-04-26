require_relative 'config_validator'
require_relative '../../../config'
require 'yaml'
require 'mqtt'

module Mqtt
  class Generic
    class BaseException < RuntimeError; end
    class DeliverException < BaseException; end
    class MissingParamException < BaseException; end

    def self.deliver(msg:)
      new.deliver(message: msg[:message], device_token: msg[:device_token])
    end

    def initialize
      @client = MQTT::Client.connect(connection_string)
    end

    def deliver(message:, device_token: nil)
      raise(MissingParamException, "error: Device Token can`t be empty") if (device_token.empty? if device_token)

      conf = config(:service)
      to = device_token.nil? ? ConfigValidator.check(conf[:path][:topic]) : \
        ("#{conf[:path][:device_token]}#{device_token}" if ConfigValidator.check(conf[:path][:device_token]))

      process_result(@client.publish(payload(to: to, message: message)))
    end

    private

    def connection_string
      ConfigValidator.check(config(:mqtt)[:mqtt][:connection_string])
    end

    def payload(to:, message:)
      {
        to: to,
        message: message
      }
    end

    def process_result(response)
      return true if response.nil?

      raise DeliverException
    end

    def config(filename)
      Mqtt::Config.new(filename).config
    end
  end
end
