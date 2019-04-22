require 'bunny'

module Sneakers
  module Testing
    class << self
      def from_queue(queue)
        connection = Bunny.new
        output = []
        connection.start
        channel  = connection.create_channel
        exchange = channel.topic('inrepublic_test')
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
    end
  end
end
