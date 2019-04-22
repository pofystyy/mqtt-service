require_relative '../../../config'
require 'mqtt'

module Mqtt
  class Generic
    class BaseException < RuntimeError; end
    class DeliverException < BaseException; end
    class MissingParamException < BaseException; end

    def self.deliver(msg:)
      new.deliver(message: msg[:message], device_token: msg[:device_token], topic: msg[:topic])
    end

    def initialize
      @client = MQTT::Client.connect('localhost')
    end

    def deliver(message:, device_token: nil, topic: nil)
      raise(MissingParamException, "error: Topic name cannot be empty") if device_token.nil? && topic.nil?
      to = device_token.nil? ? topic + config[:mqtt][:topic] : config[:mqtt][:device_token] + device_token

      process_result(@client.publish(payload(to: to, message: message)))
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

    def config
      Mqtt::Config.new(:mqtt).config
    end
  end
end
