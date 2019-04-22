class MqttWorker
  include Sneakers::Worker
  from_queue 'inrepublic.mqtt.send'.freeze,
             handler: Sneakers::Handlers::Maxretry,
             arguments: { 'x-dead-letter-exchange': 'inrepublic.mqtt.send-retry' }
  # Payload:
  # {
  #  # device_token: 'dofxnAhnLnA',
  #   topic: 'inrepublic',
  #   message: 'message'
  # }
  def work_with_params(deserialized_msg, _delivery_info, metadata)
    Sneakers.logger.info "#{self.class} #{metadata.message_id} New message. Body: #{deserialized_msg}"
    msg = JSON.parse(deserialized_msg, symbolize_names: true)
    execute(msg)
    Sneakers.logger.info "#{self.class} #{metadata.message_id} Processed without errors"
    ack!
  rescue StandardError => e
    log_error(e, deserialized_msg, metadata)
    reject!
  end

  def execute(msg)
    Mqtt::Generic.deliver(msg: msg)
  end

  def log_error(e, deserialized_msg, metadata)
    error_msg = "#{self.class} #{metadata.message_id}"\
      " Failed to proccess with exception #{e} #{e.backtrace} deserialized_msg=#{deserialized_msg}"
    Sneakers.logger.error error_msg
  end
end
