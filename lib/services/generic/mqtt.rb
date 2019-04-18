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
      if topic.nil? || topic.empty?
      raise MissingParamException, "error: Topic name cannot be empty"
      end
      # raise MissingParamException if topic.nil? || topic.empty?


      process_result(@client.publish(topic, message, retain=false))
    end

    def process_result(response)
      if response.nil?
        return true
      end
      # return true if response.nil?

      raise DeliverException
    end
  end
end
