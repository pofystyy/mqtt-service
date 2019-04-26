## Usage

Add connection string to [create MQTT::Client](https://github.com/njh/ruby-mqtt#connecting)
~~~yml
# mqtt_service/config/mqtt.yml

:mqtt:
  :connection_string: 'localhost'
~~~

Add paths to build queues in MQTT broker
~~~yml
# mqtt_service/config/service.yml

:path:
  :topic: 'queue/broadcast'           # queue name for broadcast messaging.
  :device_token: 'queue/devices/'     # queue name for direct messaging. Should end '/' to add at the end device_token
~~~


