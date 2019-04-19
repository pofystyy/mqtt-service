require 'spec_helper'

RSpec.describe MqttWorker do
  it "return true if passed valid data" do
    Bunny.create_rabbit_queue_with_data('{"topic":"inrepublic","message":"message"}')
    expect(MqttWorker.run).to eq "MqttWorker Processed without errors"
  end

  it "return exception if topic is non present" do
    Bunny.create_rabbit_queue_with_data('{"message":"message"}')
    expect(MqttWorker.run).to start_with "MqttWorker Failed to proccess with exception error: Topic name cannot be empty"
  end

  it "return exception if topic is empty" do
    Bunny.create_rabbit_queue_with_data('{"topic":"","message":"message"}')
    expect(MqttWorker.run).to start_with "MqttWorker Failed to proccess with exception error: Topic name cannot be empty"
  end
end
