require_relative '../lib/services/generic/mqtt'
require 'spec_helper'

RSpec.describe Mqtt::Generic do

  it "should create valid object (with MQTT::Client)" do
    expect(Mqtt::Generic.new.inspect).to include "MQTT::Client"
  end

  it "should be true if passed valid data" do
    msg = { topic: 'inrepublic', message: 'message' }
    expect(Mqtt::Generic.deliver(msg: msg)).to eq true
  end

  it "should be true if passed valid data" do
    msg = { device_token: 'dofxnAhnLnA', message: 'message' }
    expect(Mqtt::Generic.deliver(msg: msg)).to eq true
  end

  it "should be exception if passed invalid data" do
    expect { Mqtt::Generic.deliver( msg: { topic: nil, message: 'message' } ) }.to \
      raise_error(Mqtt::Generic::MissingParamException, "error: Topic name cannot be empty")
  end

  it "should be exception if passed invalid data" do
    expect { Mqtt::Generic.deliver( msg: { topic: '', message: 'message' } ) }.to \
      raise_error(Mqtt::Generic::MissingParamException, "error: Topic name cannot be empty")
  end

  it "should be exception if passed invalid data" do
    expect { Mqtt::Generic.deliver( msg: { device_token: nil, message: 'message' } ) }.to \
      raise_error(Mqtt::Generic::MissingParamException, "error: Topic name cannot be empty")
  end

  it "should be exception if passed invalid data" do
    expect { Mqtt::Generic.deliver( msg: { device_token: '', message: 'message' } ) }.to \
      raise_error(Mqtt::Generic::MissingParamException, "error: Topic name cannot be empty")
  end

  it "method .payload should be a class Hash" do
    expect(Mqtt::Generic.new.payload(to: 'inrepublic', message: 'message').class).to eq Hash
  end

  it "should be succes if there is a record in the database" do
    expect(Mqtt::Generic.new.process_result(nil)).to eq true
  end

  it "should be exception if the entry in the database has not occurred" do
    expect { Mqtt::Generic.new.process_result(2) }.to raise_error(Mqtt::Generic::DeliverException)
  end

  it "method .config should be a class Hash" do
    expect(Mqtt::Generic.new.config.class).to eq Hash
  end

  it "method .config should include :mqtt key" do
    expect(Mqtt::Generic.new.config).to have_key(:mqtt)
  end

  it ":mqtt key should include :topic key" do
    expect(Mqtt::Generic.new.config[:mqtt]).to have_key(:topic)
  end

  it ":mqtt key should include :device_token key" do
    expect(Mqtt::Generic.new.config[:mqtt]).to have_key(:device_token)
  end

  it "value for key :topic should be a class String" do
    expect(Mqtt::Generic.new.config[:mqtt][:topic].class).to eq String
  end

  it "value for key :device_token should be a class String" do
    expect(Mqtt::Generic.new.config[:mqtt][:device_token].class).to eq String
  end
end

