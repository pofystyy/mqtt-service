require 'bunny'
require 'json'
require 'mqtt'

module Bunny
  class << self
    def create_rabbit_queue_with_data(data)
      connection = Bunny.new
      connection.start
      channel  = connection.create_channel
      exchange = channel.direct('test')
      queue = channel.queue('test.send').bind(exchange, :routing_key => 'test.send')
      exchange.publish(data, :routing_key => 'test.send')
      connection.close
    end
  end
end


module Mqtt
  class Generic
    class BaseException < RuntimeError; end
    class DeliverException < BaseException; end
    class MissingParamException < BaseException; end

    def self.deliver(msg:)
      new.deliver(topic: msg['topic'], message: msg['message'])
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


class MqttWorker
  def self.run
    Sneakers::Testing.from_queue 'test.send'
  end

  def work_with_params(data)
    deserialized_msg, _delivery_info, metadata = data

    Sneakers::Testing.logger_info "#{self.class} New message. Body: #{deserialized_msg}"
    msg = JSON.parse(deserialized_msg)
    execute(msg)
    Sneakers::Testing.logger_info "#{self.class} Processed without errors"
    # ack!
  rescue StandardError => e
    log_error(e, deserialized_msg, metadata)
    # reject!
  end

  def execute(msg)
    Mqtt::Generic.deliver(msg: msg)
  end

  def log_error(e, deserialized_msg, metadata)
    error_msg = "#{self.class}"\
      " Failed to proccess with exception #{e} #{e.backtrace} deserialized_msg=#{deserialized_msg}"
    Sneakers::Testing.logger_error error_msg
  end
end


module Sneakers
  module Testing
    class << self
      def from_queue(queue)
        connection = Bunny.new
        output = []
        connection.start
        channel  = connection.create_channel
        exchange = channel.direct('test')
        queue = channel.queue(queue).bind(exchange, :routing_key => queue)

        queue.subscribe do |delivery_info, metadata, payload|
          output << payload << delivery_info << metadata
        end
        connection.close
        MqttWorker.new.work_with_params(output)
      end

      def logger_info(info)
        return info
      end

      def logger_error(info)
        return info
      end

      def messages_by_queue
        messages_by_queue ||= Hash.new { |hash, key| hash[key] = [] }
      end

      def clear_all
        messages_by_queue.clear
      end

    end
  end
end


RSpec.configure do |config|
  config.include Bunny
  config.include Mqtt
  config.include Sneakers::Testing

  config.before(:each) do
    Sneakers::Testing.clear_all
  end
end
