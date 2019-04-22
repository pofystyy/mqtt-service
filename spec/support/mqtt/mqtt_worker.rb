require_relative '../../../lib/services/generic/mqtt'
require_relative 'sneakers'
require 'json'

class MqttWorker
  include Mqtt
  include Sneakers::Testing

  def self.run
    Sneakers::Testing.from_queue 'inrepublic.mqtt'
  end

  def work_with_params(data)
    deserialized_msg, _delivery_info, metadata = data

    Sneakers::Testing.logger_info "#{self.class} New message. Body: #{deserialized_msg}"
    msg = JSON.parse(JSON.parse(deserialized_msg, symbolize_names: true), symbolize_names: true)
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
