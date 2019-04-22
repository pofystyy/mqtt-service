require 'bunny'

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
