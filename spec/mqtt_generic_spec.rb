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
    expect(Mqtt::Generic.new.payload(to: 'inrepublic', message: 'message').class).to eq Hash
  end

  it "should be succes if there is a record in the database" do
    expect(Mqtt::Generic.new.process_result(nil)).to eq true
  end

  it "should be exception if the entry in the database has not occurred" do
    expect { Mqtt::Generic.new.process_result(2) }.to raise_error(Mqtt::Generic::DeliverException)
  end

  it "method .config should be a class Hash" do
    expect(Mqtt::Generic.new.config(:service).class).to eq Hash
  end

  it "should include :settings_line key" do
    expect(Mqtt::Generic.new.config(:mqtt)).to have_key(:settings_line)
  end

  it "should include :path key" do
    expect(Mqtt::Generic.new.config(:service)).to have_key(:path)
  end

  it ":path key should include :topic key" do
    conf = Mqtt::Generic.new.config(:service)
    expect(conf[:path]).to have_key(:topic)
  end

  it ":path key should include :device_token key" do
    conf = Mqtt::Generic.new.config(:service)
    expect(conf[:path]).to have_key(:device_token)
  end

  it "value for key :topic should be a class String" do
    conf = Mqtt::Generic.new.config(:service)
    expect(conf[:path][:topic].class).to eq String
  end

  it "value for key :device_token should be a class String" do
    conf = Mqtt::Generic.new.config(:service)
    expect(conf[:path][:device_token].class).to eq String
  end
end

