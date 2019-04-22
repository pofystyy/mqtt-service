require_relative '../../lib/services/generic/mqtt'
require_relative 'mqtt/sneakers'
require_relative 'mqtt/bunny'

RSpec.configure do |config|
  config.include Bunny
  config.include Mqtt
  config.include Sneakers::Testing
end
