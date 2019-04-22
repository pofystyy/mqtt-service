require 'bunny'
require 'json'
require_relative '../../../config'

module RabbitWrapper
  def self.connection
    @connection ||= Bunny.new&.start
  end

  def self.channel
    @channel ||= connection.create_channel
  end

  def self.main_exchange
    exchange_name = Mailer::Config.new(:sneakers).config[:exchange]
    @main_exchange ||= channel.topic(exchange_name, durable: true)
  end

  def self.close_connection
    @connection&.close
    @connection = nil
    @channel = nil
  rescue StandardError => e
    p e # TODO: Logging
  end
end

module Bunny
  include RabbitWrapper
    def self.create_rabbit_queue_with_data(data)
      at_exit { RabbitWrapper.close_connection }

      channel = RabbitWrapper.channel
      exchange = channel.topic('inrepublic_test')
      queue = channel.queue('inrepublic.mqtt')
      queue.bind(exchange, :routing_key => queue.name)

      payload = data
      exchange.publish payload.to_json, routing_key: queue.name,
                                        content_type: 'application/json',
                                        timestamp: Time.now.to_i
    end
end
