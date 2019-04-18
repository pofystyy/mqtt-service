require 'bunny'
require 'json'
require_relative 'config'

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

at_exit { RabbitWrapper.close_connection }

channel = RabbitWrapper.channel
exchange = channel.topic('inrepublic.mqtt.send', durable: true)

payload = {
  topic: 'inrepublic',
  message: 'message'
}
exchange.publish payload.to_json, routing_key: 'inrepublic.mqtt.send',
                                  content_type: 'application/json',
                                  timestamp: Time.now.to_i
