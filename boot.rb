require 'yaml'
require 'erb'
require 'sneakers'
require 'sneakers/handlers/maxretry'
require 'sneakers/runner'
require_relative 'config'
Dir[File.dirname(__FILE__) + '/lib/services/**/*.rb'].each { |file| require file }
Dir[File.dirname(__FILE__) + '/lib/workers/**/*.rb'].each { |file| require file }

config = Mqtt::Config.new(:sneakers).config
config[:amqp] = "amqp://#{config[:amqp][:user]}:#{config[:amqp][:pass]}@#{config[:amqp][:host]}:#{config[:amqp][:port]}"

Sneakers.configure(config)
Sneakers.logger.level = Logger::INFO
r = Sneakers::Runner.new([MqttWorker])

r.run
