require_relative '../lib/services/generic/config_validator'
require 'spec_helper'

RSpec.describe Mqtt::ConfigValidator do

  it "should be true if passed valid data" do
    data = 'something'
    expect(Mqtt::ConfigValidator.check(data)).to eq data
  end

  it "should be true if passed valid data" do
    data = ''
    expect(Mqtt::ConfigValidator.check(data)).to eq data
  end

  it "should be exception if passed invalid data" do
    data = nil
    expect { Mqtt::ConfigValidator.check(data) }.to raise_error(Mqtt::ConfigValidator::MissingConfigException)
  end

  it "should be exception if passed invalid data" do
    data = []
    expect { Mqtt::ConfigValidator.check(data) }.to raise_error(Mqtt::ConfigValidator::MissingConfigException)
  end

  it "should be exception if passed invalid data" do
    data = {}
    expect { Mqtt::ConfigValidator.check(data) }.to raise_error(Mqtt::ConfigValidator::MissingConfigException)
  end

  it "should be exception if passed invalid data" do
    data = :something
    expect { Mqtt::ConfigValidator.check(data) }.to raise_error(Mqtt::ConfigValidator::MissingConfigException)
  end
end
