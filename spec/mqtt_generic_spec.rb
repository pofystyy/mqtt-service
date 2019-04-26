require_relative '../lib/services/generic/mqtt'
require 'spec_helper'

RSpec.describe Mqtt::Generic do

  it "should create valid object (with MQTT::Client)" do
    expect(Mqtt::Generic.new.inspect).to include "MQTT::Client"
  end

  it "should be true if passed valid data" do
    msg = { device_token: 'dofxnAhnLnA', message: 'message' }
    expect(Mqtt::Generic.deliver(msg: msg)).to eq true
  end

  it "should be exception if passed invalid data" do
    expect { Mqtt::Generic.deliver( msg: { device_token: '', message: 'message' } ) }.to \
      raise_error(Mqtt::Generic::MissingParamException, "error: Device Token can`t be empty")
  end

  it "method .payload should be a class Hash" do
    expect(Mqtt::Generic.new.send(:payload, to: 'inrepublic', message: 'message').class).to eq Hash
  end

  it "should be succes if there is a record in the database" do
    expect(Mqtt::Generic.new.send(:process_result, nil)).to eq true
  end

  it "should be exception if the entry in the database has not occurred" do
    expect { Mqtt::Generic.new.send(:process_result, 2) }.to raise_error(Mqtt::Generic::DeliverException)
  end

  it "method .config should be a class Hash" do
    expect(Mqtt::Generic.new.send(:config, :service).class).to eq Hash
  end

  it "should include :mqtt key" do
    expect(Mqtt::Generic.new.send(:config, :mqtt)).to have_key(:mqtt)
  end

  it "should include :connection_string key" do
    expect(Mqtt::Generic.new.send(:config, :mqtt)[:mqtt]).to have_key(:connection_string)
  end

  it "value for key :connection_string should be a class String" do
    expect(Mqtt::Generic.new.send(:config, :mqtt)[:mqtt][:connection_string].class).to eq String
  end

  it "should include :path key" do
    expect(Mqtt::Generic.new.send(:config, :service)).to have_key(:path)
  end

  it ":path key should include :topic key" do
    conf =
    expect(Mqtt::Generic.new.send(:config, :service)[:path]).to have_key(:topic)
  end

  it ":path key should include :device_token key" do
    expect(Mqtt::Generic.new.send(:config, :service)[:path]).to have_key(:device_token)
  end

  it "value for key :topic should be a class String" do
    expect(Mqtt::Generic.new.send(:config, :service)[:path][:topic].class).to eq String
  end

  it "value for key :device_token should be a class String" do
    expect(Mqtt::Generic.new.send(:config, :service)[:path][:device_token].class).to eq String
  end
end

