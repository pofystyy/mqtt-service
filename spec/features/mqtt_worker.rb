require 'spec_helper'

RSpec.describe MqttWorker do
  it "should be true if passed valid data" do
    Bunny.create_rabbit_queue_with_data('{"device_token":"dofxnAhnLnA","message":"message"}')
    expect(MqttWorker.run).to eq "MqttWorker Processed without errors"
  end

  it "should be true if passed valid data" do
    Bunny.create_rabbit_queue_with_data('{"message":"message"}')
    expect(MqttWorker.run).to start_with "MqttWorker Processed without errors"
  end

  it "should be exception if device_token is empty" do
    Bunny.create_rabbit_queue_with_data('{"device_token":"","message":"message"}')
    expect(MqttWorker.run).to start_with "MqttWorker Failed to proccess with exception error: Device Token can`t be empty"
  end
end
