require_relative '../lib/services/generic/mqtt'
require 'spec_helper'

RSpec.describe Mqtt::Generic do

  it "create valid object (with MQTT::Client)" do
    expect(Mqtt::Generic.new.inspect).to include "MQTT::Client"
  end

  it "return true if passed valid data" do
    msg = { topic: 'inrepublic', message: 'message' }
    expect(Mqtt::Generic.deliver(msg: msg)).to eq true
  end

  it "return true if passed valid data" do
    msg = { device_token: 'dofxnAhnLnA', message: 'message' }
    expect(Mqtt::Generic.deliver(msg: msg)).to eq true
  end

  it "return exception if passed invalid data" do
    expect { Mqtt::Generic.new.deliver(topic: nil, message: 'message') }.to \
      raise_error(Mqtt::Generic::MissingParamException, "error: Topic name cannot be empty")
  end

  it "should be succes if there is a record in the database" do
    expect(Mqtt::Generic.new.process_result(nil)).to eq true
  end

  it "return exception if the entry in the database has not occurred" do
    expect { Mqtt::Generic.new.process_result(2) }.to raise_error(Mqtt::Generic::DeliverException)
  end
end

