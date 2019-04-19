require 'mqtt'

module Mqtt
  class Generic
    class BaseException < RuntimeError; end
    class DeliverException < BaseException; end
    class MissingParamException < BaseException; end

    def self.deliver(msg:)
      new.deliver(topic: msg[:topic], message: msg[:message])
    end

    def initialize
      @client = MQTT::Client.connect('localhost')
    end

    def deliver(topic:, message:)
      raise(MissingParamException, "error: Topic name cannot be empty") if topic.nil? || topic.empty?

      process_result(@client.publish(topic, message, retain=false))
    end

    def process_result(response)
      return true if response.nil?

      raise DeliverException
    end
  end
end
